class TermsController < ApplicationController
  before_action :set_person_and_terms

  def terms_dropdown
    if session[:term].nil?
      session[:term] = @terms[0]
    end
    respond_to do |format|
      format.html { render partial: 'terms_dropdown', layout: false }
      format.json { render json: @terms }
      format.turbo_stream
    end
  end

  def set_term
    if params[:term_index]
      puts "SESSION " + session.inspect
      session[:term] = @terms[params[:term_index].to_i]
    end
    redirect_to controller: "course_offerings", action: "index", term_id: @terms[params[:term_index].to_i]["id"], term_name: @terms[params[:term_index].to_i]["name"]
  end

end
