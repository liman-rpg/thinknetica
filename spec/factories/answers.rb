FactoryGirl.define do
  sequence :body do |n|
    "MyText#{n}"
  end

  factory :answer do
    body
    question
    user
    best false
  end

  factory :invalid_answer, class:"Answer" do
    body nil
  end
end
