module ApplicationHelper
  # The top bar's links for the signed-in role. Staff get a count of waiting
  # requests on Requests.
  def nav_links
    if current_user.staff?
      [
        { label: "Requests", path: staff_home_path, active: controller_path.start_with?("staff/requests"), count: waiting_badge_count },
        { label: "Courses", path: staff_courses_home_path, active: controller_name.in?(%w[ courses course_offerings ]) }
      ]
    else
      [
        { label: "Find courses", path: student_home_path, active: controller_name.in?(%w[ courses course_offerings ]) },
        { label: "My requests", path: my_requests_home_path, active: controller_name.in?(%w[ requests registration_requests ]) }
      ]
    end
  end

  # The layout must render even on the "API is down" page, so these helpers
  # fall back instead of raising.
  def current_viewer_terms
    current_viewer.terms
  rescue ApiService::Error
    []
  end

  def viewer_display_name
    current_viewer.name
  rescue ApiService::Error
    current_user.email
  end

  def waiting_badge_count
    controller.respond_to?(:waiting_count_for_badge, true) ? controller.send(:waiting_count_for_badge) : nil
  rescue ApiService::Error
    nil
  end

  # Status is always a coloured badge with a plain word (U3).
  def status_badge(status)
    tag.span(RequestStatus.label(status), class: [ "badge", status ])
  end

  def dom_id_for(waitlist_request)
    "request-#{waitlist_request.id.to_s.parameterize}"
  end
end
