FactoryGirl.define do
  sequence :uid do |n|
    "uid#{n}"
  end

  factory :identity do
    provider "facebook"
    uid

    trait :with_user do
      association :user, strategy: :build
    end
  end
end
