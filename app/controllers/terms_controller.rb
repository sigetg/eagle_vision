# The term picker in the top bar posts here. One route for every page: it
# saves the chosen term in the session and goes back where it came from.
class TermsController < ApplicationController
  def update
    authorize :term, :update?
    term = current_viewer.terms.find { |candidate| candidate["id"] == params[:term_id] }
    session[:term] = term if term
    redirect_to safe_return_path
  end

  private

  def safe_return_path
    path = params[:return_to].to_s
    path.start_with?("/") && !path.start_with?("//") ? path : root_path
  end
end
