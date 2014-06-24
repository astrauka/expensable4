FactoryGirl.define do
  factory :share do
    association :expense, strategy: :build
    association :user, strategy: :build

    multiplier 1
    single_price 10
  end
end
