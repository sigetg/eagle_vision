module CoursesHelper
  GRADING_WORDS = { "letter" => "Letter", "pf" => "Pass/Fail", "audit" => "Audit" }.freeze

  # A course description without BC's inline styles and tags (P1, P2).
  def plain_description(course)
    strip_tags(course.descr&.dig("plain").to_s).squish
  end

  def course_description(course)
    sanitize(course.descr&.dig("formatted").to_s, tags: %w[ p br ul ol li em strong a ], attributes: %w[ href ])
  end

  # "kuali.result.values.group.credit.degree.4.0" => "4 credits"
  def course_credits(course)
    number = course.creditOptionId.to_s[/(\d+(?:\.\d+)?)\z/, 1]
    number ? pluralize(number.to_f.to_s.sub(/\.0\z/, ""), "credit") : nil
  end

  def course_gradings(course)
    Array(course.gradingOptionIds).push(*Array(course.studentRegistrationGradingOptionIds))
                                 .map { |id| GRADING_WORDS[id.to_s.split(".").last] || id.to_s.split(".").last.titleize }.uniq
  end

  # Where "Request a spot" goes. PR 9 replaces this with the new form.
  def new_spot_request_path(_course, option)
    new_registration_request_path(registration_group_id: option.group_id, activity_offering_ids: option.sections.map(&:id).join(" "))
  end

  def filter_query(overrides = {})
    request.query_parameters.except("page").merge(overrides.stringify_keys)
  end
end
