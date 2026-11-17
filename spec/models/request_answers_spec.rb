require "rails_helper"

RSpec.describe RequestAnswers do
  it "reads answers stored as JSON" do
    answers = described_class.parse({ class_year: "Junior", major: "Math", reason: "Required" }.to_json)
    expect([ answers.class_year, answers.major, answers.reason ]).to eq([ "Junior", "Math", "Required" ])
  end

  it "still reads 2024 answers joined with a literal backslash-n" do
    answers = described_class.parse('Sophomore\nEconomics\nI need this course.')
    expect([ answers.class_year, answers.major, answers.reason ]).to eq([ "Sophomore", "Economics", "I need this course." ])
  end

  it "requires a reason of at most 1,000 characters" do
    answers = described_class.new(class_year: "Senior", major: "History", reason: "x" * 1001)
    expect(answers).not_to be_valid
    expect(answers.errors[:reason]).to be_present
  end
end
