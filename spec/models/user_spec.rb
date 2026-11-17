require "rails_helper"

RSpec.describe User do
  it "re-checks the role against the API" do
    user = create_waitlist_user(:student)
    expect(user).to be_student
    stub_waitlist_api(:person, id: "90000001", fixture: "person_staff")

    user.sync_role!

    expect(user.reload).to be_staff
  end
end
