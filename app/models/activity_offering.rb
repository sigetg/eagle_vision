class ActivityOffering
  include ActiveModel::Model

  attr_accessor \
    :attributes,
    :meta,
    :id,
    :typeKey,
    :stateKey,
    :effectiveDate,
    :expirationDate,
    :name,
    :descr,
    :formatOfferingId,
    :formatOfferingName,
    :activityId,
    :termId,
    :termCode,
    :activityCode,
    :scheduleIds,
    :isHonorsOffering,
    :instructors,
    :weeklyInclassContactHours,
    :weeklyTotalContactHours,
    :maximumEnrollment,
    :minimumEnrollment,
    :isEvaluated,
    :activityOfferingUrl,
    :courseOfferingId,
    :courseOfferingTitle,
    :courseOfferingCode,
    :weeklyOutofClassHours,
    :unitsDeploymentOrgIds,
    :requisiteIds,
    :coRequisiteIds,
    :restrictionIds,
    :type,
    :state,
    :scheduleNames

  attr_accessor :seatCount

  def lecture? = typeKey.to_s.end_with?(".lecture")
  def kind = typeKey.to_s.split(".").last.to_s.capitalize
  def seats_total = seatCount&.dig("total").to_i
  def seats_used = seatCount&.dig("used").to_i
  def seats_available = seatCount&.dig("available").to_i
  def full? = seats_available <= 0

  def instructor_names
    Array(instructors).filter_map { |instructor| instructor["personName"] }
  end

  # "245 Beacon Street Room 102 TuTh 09:00AM-10:15AM" splits into the room,
  # the days and the times.
  def schedule
    @schedule ||= SectionSchedule.parse(scheduleNames)
  end
end
