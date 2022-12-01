FactoryBot.define do
    factory :user do
      email  { FFaker::Internet.unique.email }
      password { 'password' }
      password_confirmation { 'password' }
      first_name { FFaker::Name.first_name }
      last_name { FFaker::Name.last_name }
    end
end