FactoryGirl.define do
  sequence :body do |n|
    "MyText#{n}"
  end

  factory :answer do
    body
    question
    user
    best false

    trait :with_attachment do
      after(:create) { |answer| create(:attachment, attachable: answer) }
    end
  end

  factory :invalid_answer, class:"Answer" do
    body nil
  end
end
