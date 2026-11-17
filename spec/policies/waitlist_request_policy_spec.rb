require "rails_helper"

RSpec.describe WaitlistRequestPolicy do
  let(:section) { ActivityOffering.new(id: "ao-1", unitsDeploymentOrgIds: [ "dept-cs" ]) }
  let(:api) { instance_double(ApiService) }

  def viewer(role:, person_id:, department_ids: [])
    user = build(:user, role: role, person_id: person_id)
    instance_double(Viewer, student?: role == :student, staff?: role == :staff,
                            person_id: person_id.to_s, department_ids: department_ids)
      .tap { |double| allow(double).to receive(:user).and_return(user) }
  end

  def waitlist_request(status: :waiting, student_id: "90000001")
    request = RegistrationRequest.new(id: "req-1", requestorId: student_id, stateKey: RequestStatus.key_for(status))
    item = RegistrationRequestItem.new(preferredActivityOfferingIds: [ "ao-1" ])
    WaitlistRequest.new(request, item).tap { |wr| wr.sections = [ section ] }
  end

  let(:owner) { viewer(role: :student, person_id: 90000001) }
  let(:other_student) { viewer(role: :student, person_id: 90000002) }
  let(:cs_staff) { viewer(role: :staff, person_id: 90000000, department_ids: [ "dept-cs" ]) }
  let(:math_staff) { viewer(role: :staff, person_id: 90000009, department_ids: [ "dept-math" ]) }

  it "lets a student see, edit and withdraw their own waiting request" do
    policy = described_class.new(owner, waitlist_request)
    expect([ policy.show?, policy.update?, policy.destroy? ]).to all(be(true))
    expect(policy.decide?).to be(false)
  end

  it "makes a decided request read-only for its student" do
    policy = described_class.new(owner, waitlist_request(status: :accepted))
    expect(policy.show?).to be(true)
    expect([ policy.update?, policy.destroy? ]).to all(be(false))
  end

  it "keeps other students out" do
    policy = described_class.new(other_student, waitlist_request)
    expect([ policy.show?, policy.update?, policy.destroy? ]).to all(be(false))
  end

  it "lets staff see and decide only within their departments" do
    expect(described_class.new(cs_staff, waitlist_request).decide?).to be(true)
    expect(described_class.new(cs_staff, waitlist_request).show?).to be(true)
    expect(described_class.new(math_staff, waitlist_request).decide?).to be(false)
    expect(described_class.new(math_staff, waitlist_request).show?).to be(false)
  end

  it "never lets staff create, edit or withdraw requests" do
    policy = described_class.new(cs_staff, waitlist_request)
    expect([ policy.create?, policy.update?, policy.destroy? ]).to all(be(false))
  end
end
