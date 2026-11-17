# One short email per decision (E1, A5): accepted, declined or reopened.
class DecisionMailer < ApplicationMailer
  SUBJECT_WORDS = { accepted: "was accepted", declined: "was declined", waiting: "was reopened" }.freeze

  def decided
    @status = params[:status].to_sym
    @course_code = params[:course_code]
    @sections = params[:sections]
    @message = params[:message]
    @department = params[:department]
    mail(to: params[:to], subject: "Your waitlist request for #{@course_code} #{SUBJECT_WORDS.fetch(@status)}")
  end
end
