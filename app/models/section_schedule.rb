# A section's meeting pattern, parsed from the API's schedule name, such as
# "245 Beacon Street Room 102 TuTh 09:00AM-10:15AM" or
# "Campion Hall 139 MWF 12:00 Noon-12:50PM".
class SectionSchedule
  DAY_CODES = %w[ M Tu W Th F ].freeze
  PATTERN = /\A(?<room>.*?)\s*(?<days>(?:M|Tu|W|Th|F|Sa|Su)+)\s+(?<start>\d{1,2}:\d{2}\s*(?:AM|PM|Noon))\s*-\s*(?<finish>\d{1,2}:\d{2}\s*(?:AM|PM|Noon))\s*\z/

  attr_reader :text, :room, :days, :start_minutes, :finish_minutes

  def self.parse(text)
    new(text.to_s.strip)
  end

  def initialize(text)
    @text = text
    match = PATTERN.match(text)
    @days = []
    return unless match

    @room = match[:room].presence
    @days = match[:days].scan(/Tu|Th|Sa|Su|M|W|F/)
    @start_minutes = self.class.minutes(match[:start])
    @finish_minutes = self.class.minutes(match[:finish])
  end

  def known? = start_minutes.present?

  def time_text
    return text unless known?

    "#{days.join} #{self.class.clock(start_minutes)}-#{self.class.clock(finish_minutes)}"
  end

  # "09:00AM" => 540, "12:00 Noon" => 720, "01:00PM" => 780
  def self.minutes(clock)
    hours, minutes = clock[/\d{1,2}:\d{2}/].split(":").map(&:to_i)
    hours += 12 if clock.include?("PM") && hours != 12
    hours = 0 if clock.include?("AM") && hours == 12
    hours * 60 + minutes
  end

  def self.clock(minutes)
    hours, mins = minutes.divmod(60)
    suffix = hours >= 12 ? "pm" : "am"
    hours -= 12 if hours > 12
    format("%d:%02d%s", hours, mins, suffix)
  end
end
