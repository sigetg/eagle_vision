# One row on the course page: a combination of sections a student signs up
# for together. The API has one sign-up option per grading variant (Letter,
# Pass/Fail) of the same sections; the course page shows them as one row
# (P2), so a SectionOption holds every variant's group id.
class SectionOption
  attr_reader :sections, :groups

  def self.from_groups(groups)
    groups.group_by { |group| group[:activity_offerings].map(&:id).sort }
          .map { |_ids, variants| new(variants) }
          .sort_by { |option| option.sections.map(&:activityCode).join(",") }
  end

  def initialize(variants)
    @groups = variants.map { |variant| variant[:registration_group] }
    @sections = variants.first[:activity_offerings].sort_by { |section| section.lecture? ? 0 : 1 }
  end

  # The group a request is sent for: the Letter variant if there is one.
  def group_id
    (groups.find { |group| grading(group) == "Letter" } || groups.first).id
  end

  def group_ids = groups.map(&:id)
  def gradings = groups.map { |group| grading(group) }.compact.uniq
  def codes = sections.map(&:activityCode).join(", ")
  def full? = sections.any?(&:full?)
  def open? = !full?

  private

  # "03, 17 - Pass/Fail - CSCI1101" => "Pass/Fail"
  def grading(group)
    group.name.to_s.split(" - ")[1]
  end
end
