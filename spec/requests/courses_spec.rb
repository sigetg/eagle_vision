require "rails_helper"

RSpec.describe "Find courses and the course page", type: :request do
  let(:term_id) { "kuali.atp.FA2023-2024" }

  before do
    stub_waitlist_api(:course_offerings, query: { termId: term_id, code: "" }, fixture: "course_offerings")
    stub_waitlist_api(:registration_groups, query: { courseOfferingId: "co-1" }, fixture: "registration_groups")
    stub_request(:get, "#{WaitlistApiHelpers::BASE_URL}/waitlistregistrationgroups")
      .with(query: { courseOfferingId: "co-2" }).to_return(body: "[]")
  end

  def course_codes
    Nokogiri::HTML(response.body).css(".course-card .code").map(&:text)
  end

  context "as a student" do
    before { sign_in create_waitlist_user(:student) }

    it "lists the term's courses with a seats summary" do
      get courses_path

      expect(response).to have_http_status(:ok)
      expect(course_codes).to eq(%w[ TEST1101 TEST2201 ])
      expect(response.body).to include("2 courses", "Open in 8 of 50", "3 credits")
    end

    it "searches by code or title" do
      get courses_path(q: "fixtures")

      expect(course_codes).to eq(%w[ TEST2201 ])
    end

    it "filters by level" do
      get courses_path(level: "2000")

      expect(course_codes).to eq(%w[ TEST2201 ])
    end

    it "filters by days, time of day, professor and open seats, using the sections" do
      get courses_path(days: %w[ Tu Th ], time: "early")
      expect(course_codes).to eq(%w[ TEST1101 ])

      get courses_path(days: %w[ M ])
      expect(course_codes).to eq([])

      get courses_path(time: "afternoon", open: "1")
      expect(course_codes).to eq(%w[ TEST1101 ])

      get courses_path(professor: "nobody")
      expect(course_codes).to eq([])
    end

    it "shows a course page with one row per section combination and Request a spot" do
      get course_path("co-1")

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Introduction to Testing", "Lecture 01", "Discussion 02", "30 / 30", "12 / 20",
                                        "Full", "Request a spot")
      expect(response.body).not_to include("Requests</h2>")
    end

    it "returns 404 for a course the term doesn't have" do
      get course_path("nope")

      expect(response).to have_http_status(:not_found)
    end
  end

  context "as staff" do
    before do
      sign_in create_waitlist_user(:staff)
      stub_waitlist_api(:requests, query: { termId: term_id, deptId: "dept-cs" }, fixture: "department_requests")
      stub_waitlist_api(:requests, query: { courseOfferingId: "co-1" }, fixture: "department_requests")
      stub_waitlist_api(:activity_offering, id: "ao-lec-01", fixture: "activity_offering")
      stub_waitlist_api(:person, id: "90000001", fixture: "person_student")
      stub_waitlist_api(:person, id: "90000002", fixture: "person_other_student")
    end

    it "shows a waiting count on each card and filters to courses with waiting requests" do
      get courses_path(waiting: "1")

      expect(course_codes).to eq(%w[ TEST1101 ])
      expect(response.body).to include("2 waiting")
    end

    it "lists the course's requests below its sections, without Request buttons" do
      get course_path("co-1")

      expect(response.body).to include("Requests</h2>", "Testperson, Avery")
      expect(response.body).not_to include("Request a spot")
    end
  end
end
