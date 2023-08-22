class CourseOffering
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
    :courseId,
    :termId,
    :courseOfferingTitle,
    :courseCode,
    :courseOfferingCode,
    :courseNumberSuffix,
    :subjectAreaId,
    :isHonorsOffering,
    :campusLocations,
    :instructors,
    :unitsDeploymentOrgIds,
    :requisiteIds,
    :gradingOptionId,
    :gradingOptionIds,
    :studentRegistrationGradingOptionIds,
    :creditOptionId,
    :coRequisiteIds,
    :restrictionIds,
    :maximumEnrollment,
    :minimumEnrollment,
    :isEvaluated,
    :courseOfferingUrl,
    :gradeRosterDefinitionId,
    :creditOptionIds,
    :type,
    :state
  # self.site = "http://127.0.0.1:3000"

  # belongs_to :term
  # has_many :activity_offerings
end
