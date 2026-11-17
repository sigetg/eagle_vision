# What a student wrote on the request form. New requests store these as JSON
# in the request's descr.plain; 2024 requests joined them with a literal
# backslash-n, and parse still reads those.
# See docs/adr/2026-11-16-request-answers-stored-as-json.md.
class RequestAnswers
  include ActiveModel::Model
  include ActiveModel::Validations

  CLASS_YEARS = [ "First year", "Sophomore", "Junior", "Senior", "Graduate" ].freeze
  REASON_LIMIT = 1000

  attr_accessor :class_year, :major, :reason, :grading

  validates :class_year, inclusion: { in: CLASS_YEARS, message: "must be chosen" }
  validates :major, presence: true
  validates :reason, presence: true, length: { maximum: REASON_LIMIT }

  def self.parse(text)
    return new if text.blank?

    data = JSON.parse(text)
    new(data.slice("class_year", "major", "reason", "grading"))
  rescue JSON::ParserError, TypeError
    year, major, *reason = text.split('\n')
    new(class_year: year, major: major, reason: reason.join("\n"))
  end

  def to_json(*)
    { class_year: class_year, major: major, reason: reason, grading: grading }.compact.to_json
  end
end
