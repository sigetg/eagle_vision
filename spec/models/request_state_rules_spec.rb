require "rails_helper"

RSpec.describe RequestStateRules do
  it "allows deciding a waiting request and reopening a decided one" do
    expect(described_class.allowed?(:waiting, :accepted)).to be(true)
    expect(described_class.allowed?(:waiting, :declined)).to be(true)
    expect(described_class.allowed?(:accepted, :waiting)).to be(true)
    expect(described_class.allowed?(:declined, :waiting)).to be(true)
  end

  it "refuses every other move" do
    expect(described_class.allowed?(:accepted, :declined)).to be(false)
    expect(described_class.allowed?(:declined, :accepted)).to be(false)
    expect(described_class.allowed?(:waiting, :waiting)).to be(false)
    expect(described_class.allowed?(nil, :accepted)).to be(false)
  end
end
