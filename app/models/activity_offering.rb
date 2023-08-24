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

  # belongs_to :term
  # belongs_to :course_offering
end
