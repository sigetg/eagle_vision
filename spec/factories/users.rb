FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "9#{n.to_s.rjust(7, '0')}@bc.edu" }
    password { "test-password-1" }
    person_id { email.split("@").first.to_i }
  end
end
