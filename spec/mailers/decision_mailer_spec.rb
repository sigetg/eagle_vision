require "rails_helper"

RSpec.describe DecisionMailer do
  def email(status:, message: nil)
    described_class.with(to: "90000001@bc.edu", status: status, course_code: "TEST1101", sections: "01, 02",
                         message: message, department: "Computer Science").decided
  end

  it "says the request was accepted, with the staff message and a link back" do
    mail = email(status: "accepted", message: "You're in.")

    expect(mail.subject).to eq("Your waitlist request for TEST1101 was accepted")
    expect(mail.to).to eq([ "90000001@bc.edu" ])
    expect(mail.text_part.body.to_s).to include("You're in.", "/requests", "Computer Science", "inbox isn't read")
    expect(mail.html_part.body.to_s).to include("View my requests")
  end

  it "has a subject for declined and reopened requests" do
    expect(email(status: "declined").subject).to end_with("was declined")
    expect(email(status: "waiting").subject).to end_with("was reopened")
  end
end
