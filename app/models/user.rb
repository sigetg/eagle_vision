class User < ApplicationRecord
  # has_one :person
  after_create :assign_default_role
  rolify

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
      #fill out person data associated with user
      if data = User.fetch_data_from_api(user.email)[0]
        user.person_id = data['id']
        user.typeKey = data['typeKey']
        user.stateKey = data['stateKey']
        user.name = data['name']
        user.descr = data['descr']
        user.pictureDocumentId = data['pictureDocumentId']
        user.meta = data['meta']
        user.person_email = data['person_email']
      end
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end


  def self.fetch_data_from_api(email)
    uri = URI("http://127.0.0.1:3000/people?person_email=#{email}")
    response = Net::HTTP.get_response(uri)
    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      # Process the API response and return the necessary data
      # For example: data['name'], data['age'], etc.
    else
      Rails.logger.error("API Error: #{response.code} - #{response.message}")
      nil
    end
  rescue StandardError => e
    Rails.logger.error("API Error: #{e.message}")
    nil
  end

  private

  def assign_default_role
    if has_role?(:user)
      puts "User already has role"
    else
      add_role(:user) # Change 'user' to the desired default role. Current roles are user and admin.
    end
  end
end
