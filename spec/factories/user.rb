FactoryGirl.define do
  factory :user do
    first_name  Faker::Name.name.split(' ')[0]
    last_name   Faker::Name.name.split(' ')[1]
  end
end
