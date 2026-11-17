# The only moves staff can make on a request: decide a waiting one, or
# reopen a decided one. Everything else is refused.
module RequestStateRules
  MOVES = {
    waiting: %i[ accepted declined ],
    accepted: %i[ waiting ],
    declined: %i[ waiting ]
  }.freeze

  # The status a staff action leads to.
  ACTIONS = { "accept" => :accepted, "decline" => :declined, "reopen" => :waiting }.freeze

  def self.allowed?(from, to)
    MOVES.fetch(from&.to_sym, []).include?(to&.to_sym)
  end
end
