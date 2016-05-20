FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.ru"
  end

  factory :user do
    email
    password '1234567890'
    password_confirmation '1234567890'
  end
end
