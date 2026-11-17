# Pages only staff can open.
module Staff
  class BaseController < ApplicationController
    before_action :require_staff

    private

    def require_staff
      raise Pundit::NotAuthorizedError, "staff only" unless current_user.staff?
    end
  end
end
