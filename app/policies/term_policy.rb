# Anyone signed in may switch terms.
class TermPolicy < ApplicationPolicy
  def update? = true
  def index? = true
end
