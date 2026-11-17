# The courses of one term, with the filters on Find courses (P1, S1).
#
# The API returns every course of a term in one fast call, so the cheap
# filters (search, department, level) run in Ruby. The section filters
# (days, time of day, professor, open seats) need each course's sign-up
# options, one call per course; those are fetched in parallel, only for the
# courses left after the cheap filters, and cached for a few minutes.
class CourseCatalog
  PER_PAGE = 20
  LEVELS = %w[ 1000 2000 3000 4000 ].freeze
  DAYS = SectionSchedule::DAY_CODES
  TIMES = {
    "early" => [ "Before 10", 0, 600 ],
    "late_morning" => [ "10 to 12", 600, 720 ],
    "midday" => [ "12 to 2", 720, 840 ],
    "afternoon" => [ "2 to 6", 840, 1080 ],
    "evening" => [ "After 6", 1080, 1440 ]
  }.freeze
  THREADS = 8

  Filters = Struct.new(:q, :department, :level, :days, :time, :professor, :open, :waiting, keyword_init: true) do
    def sections? = days.present? || time.present? || professor.present? || open
  end

  def initialize(api:, term_id:)
    @api = api
    @term_id = term_id
  end

  def courses
    @courses ||= Rails.cache.fetch([ "courses", @term_id ], expires_in: 5.minutes) do
      @api.fetch_and_map_waitlistcourseofferings(@term_id, "")
    end.sort_by { |course| course.courseOfferingCode.to_s }
  end

  def find(id)
    courses.find { |course| course.id == id } || raise(ApiService::NotFound.new(id))
  end

  # Subject codes (CSCI, ECON) present in this term, for the department filter.
  def departments
    courses.map { |course| self.class.subject(course) }.uniq.sort
  end

  def self.subject(course) = course.courseOfferingCode.to_s[/\A[A-Z]+/]
  def self.level(course) = course.courseOfferingCode.to_s[/\d/]

  # The sign-up options of one course: [{ registration_group:, activity_offerings: }]
  def groups(course_id)
    Rails.cache.fetch([ "groups", course_id ], expires_in: 2.minutes) do
      ApiService.new.fetch_and_map_waitlistregistrationgroups(course_id)
    end
  end

  def search(filters, within: courses)
    rows = within
    if filters.q.present?
      query = filters.q.downcase.delete(" ")
      rows = rows.select do |course|
        course.courseOfferingCode.to_s.downcase.include?(query) ||
          course.courseOfferingTitle.to_s.downcase.include?(filters.q.downcase)
      end
    end
    rows = rows.select { |course| self.class.subject(course) == filters.department } if filters.department.present?
    rows = rows.select { |course| self.class.level(course) == filters.level.first } if filters.level.present?
    return rows unless filters.sections?

    prefetch_groups(rows)
    rows.select { |course| sections(course).any? { |section| section_matches?(section, filters) } }
  end

  # Every section of a course, once each.
  def sections(course)
    groups(course.id).flat_map { |group| group[:activity_offerings] }.uniq(&:id)
  end

  # "Open in 12 of 22" or "Full", counting each section once.
  def seats_summary(course)
    all = sections(course)
    return nil if all.empty?

    open = all.sum(&:seats_available)
    open.positive? ? "Open in #{open} of #{all.sum(&:seats_total)}" : "Full"
  end

  def prefetch_groups(rows)
    missing = rows.reject { |course| Rails.cache.exist?([ "groups", course.id ]) }
    missing.each_slice((missing.size / THREADS.to_f).ceil.clamp(1, 1000)).map do |slice|
      Thread.new do
        Rails.application.executor.wrap do
          slice.each do |course|
            groups(course.id)
          rescue ApiService::Error
            nil
          end
        end
      end
    end.each(&:join)
  end

  private

  def section_matches?(section, filters)
    schedule = section.schedule
    return false if filters.open && section.full?
    return false if filters.days.present? && !(schedule.days - filters.days).empty?
    return false if filters.days.present? && schedule.days.empty?
    if filters.time.present?
      _label, from, to = TIMES[filters.time]
      return false unless schedule.known? && schedule.start_minutes >= from && schedule.start_minutes < to
    end
    if filters.professor.present?
      return false unless section.instructor_names.any? { |name| name.downcase.include?(filters.professor.downcase) }
    end
    true
  end
end
