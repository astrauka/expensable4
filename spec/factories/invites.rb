FactoryGirl.define do
  factory :invite do
    association :group, strategy: :build
    uid "12345"

    trait :accepted do
      accepted true
    end
  end
end
