FactoryGirl.define do
  sequence(:email) { |n| "email#{n}_#{rand(100)}@factory.com" }

  factory :user do
    email
    password '12345678'
  end
end
