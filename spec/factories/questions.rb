FactoryGirl.define do
  sequence(:title) { |n| "MyTitle#{n}" }

  factory :question do
    title
    body "MyText"
    user

    trait :with_attachment do
      after(:create) { |question| create(:attachment, attachable: question) }
    end
  end

  factory :invalid_question, class:"Question" do
    title nil
    body nil
  end

  factory :old_question, class:"Question" do
     title 'Old question'
     created_at Time.zone.now - 2.days
  end
end
