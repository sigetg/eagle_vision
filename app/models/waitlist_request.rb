# One waitlist request, wrapping the two objects the API returns for it
# (registrationRequest and registrationRequestItem) with the words the app
# uses: status, answers, decision, sections.
#
# sections and student_name come from other API calls, so a controller (or
# WaitlistRequestLoader) fills them in.
class WaitlistRequest
  attr_reader :request, :item
  attr_accessor :sections, :student_name, :department_id

  def self.from_api(data)
    new(data[:registrationRequest], data[:registrationRequestItem])
  end

  def initialize(request, item)
    @request = request
    @item = item
    @sections = []
  end

  def id = request.id
  def student_id = request.requestorId.to_s
  def term_id = request.termId
  def status = RequestStatus.from_key(request.stateKey)
  def waiting? = status == :waiting
  def decided? = %i[ accepted declined ].include?(status)

  def answers
    @answers ||= RequestAnswers.parse(request.descr&.dig("plain"))
  end

  def decision
    @decision ||= StaffDecision.parse(request.descr&.dig("formatted"))
  end

  def sent_at
    Time.zone.parse(request.effectiveDate.to_s) if request.effectiveDate.present?
  end

  # The 2024 form saved the section ids as one space-separated string.
  def section_ids
    Array(item.preferredActivityOfferingIds).flat_map { |ids| ids.to_s.split }
  end

  def group_ids
    Array(item.preferredRegistrationGroupIds)
  end

  # "Waitlist request for 01, 02 - Letter - CSCI1101" names the course last.
  def course_code
    sections.first&.courseOfferingCode || request.name.to_s.split.last
  end

  def course_title = sections.first&.courseOfferingTitle
  def course_offering_id = sections.first&.courseOfferingId

  def department_ids
    sections.flat_map { |section| Array(section.unitsDeploymentOrgIds) }.map(&:to_s).uniq
  end

  def section_codes
    sections.map(&:activityCode).join(", ")
  end

  def open_seats
    sections.sum { |section| section.seats_available.to_i }
  end

  def answers=(answers)
    @answers = answers
    request.descr = (request.descr || {}).merge("plain" => answers.to_json)
  end

  def decision=(decision)
    @decision = decision
    request.descr = (request.descr || {}).merge("formatted" => decision.to_json)
  end

  # The body the API expects on PUT /waitlistrequests/:id.
  def to_api
    { registrationRequest: request, registrationRequestItem: item }
  end
end
