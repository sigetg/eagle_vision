# The staff side of a request: the message to the student, who decided and
# when. Stored as JSON in the request's descr.formatted. 2024 requests stored
# only the message there (or the word "Pending"), and parse still reads those.
class StaffDecision
  include ActiveModel::Model

  attr_accessor :message, :decided_by, :decided_at

  def self.parse(text)
    return new if text.blank? || text == "Pending"

    data = JSON.parse(text)
    data.is_a?(Hash) ? new(data.slice("message", "decided_by", "decided_at")) : new(message: text)
  rescue JSON::ParserError
    new(message: text)
  end

  def decided_at_time
    Time.zone.parse(decided_at.to_s) if decided_at.present?
  end

  def to_json(*)
    { message: message, decided_by: decided_by, decided_at: decided_at }.compact.to_json
  end
end
