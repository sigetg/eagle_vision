# The base for every policy. `user` is a Viewer (see app/models/viewer.rb),
# and every rule says no unless a policy says yes.
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index? = false
  def show? = false
  def new? = create?
  def create? = false
  def edit? = update?
  def update? = false
  def destroy? = false
end
