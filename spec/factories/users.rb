FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    first_name "John"
    last_name "Bundler"
    email

    trait :with_identity do
      association :identity, strategy: :build
    end
  end
end
