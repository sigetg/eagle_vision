module ActivityOfferingsHelper

  #format the instructor names for the activity offering
  def format_instructor_names(names)
    if names.length > 1
      names.join(', ')
    else
      names.first
    end
  end
end
