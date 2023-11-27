class User < ApplicationRecord
  # has_one :person
  after_create :assign_default_role
  rolify
  belongs_to :person, class_name: 'Person', optional: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth.info.name # assuming the user model has a name
      user.avatar_url = auth.info.image # assuming the user model has an image
      api_service = ApiService.new
      person, terms = api_service.fetch_and_map_waitlistperson_and_term(user.email.split("@")[0])
      user.person_id = person.id
      puts user.inspect
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  private

  def assign_default_role
    api_service = ApiService.new
    affiliations, departments = api_service.fetch_and_map_waitlistperson_affiliations_and_authorized_departments(self.person_id)
    is_admin = false
    for affiliation in affiliations
      if affiliation.type["name"] == "Staff"
        is_admin = true
      end
    end
    if is_admin
      add_role(:admin)
    else
      add_role(:user)
    end
  end

end
