class User < ApplicationRecord
  # A student finds courses and sends waitlist requests; staff decide on them.
  # The waitlist API decides which, from the person's affiliations, and the
  # role is checked again at every sign-in (config/initializers/warden_hooks.rb).
  enum :role, { student: 0, staff: 1 }, default: :student, validate: true

  before_create :assign_role_from_api

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [ :google_oauth2 ]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth.info.name
      user.avatar_url = auth.info.image
      person, _terms = ApiService.new.fetch_and_map_waitlistperson_and_term(user.email.split("@")[0])
      user.person_id = person.id
    end
  end

  # Asks the API for this person's affiliations and saves the role if it
  # changed. Called after every sign-in.
  def sync_role!(api = ApiService.new)
    self.role = role_from_api(api)
    save! if role_changed?
  end

  private

  def assign_role_from_api
    self.role = role_from_api(ApiService.new)
  end

  def role_from_api(api)
    affiliations, _departments = api.fetch_and_map_waitlistperson_affiliations_and_authorized_departments(person_id.to_s)
    affiliations.any? { |affiliation| affiliation.type&.dig("name") == "Staff" } ? :staff : :student
  end
end
