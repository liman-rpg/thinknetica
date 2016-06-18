FactoryGirl.define do
  factory :vote do
    user
    score 0

    trait :up do
      score 1
    end

    trait :down do
      score -1
    end
  end
end
