FactoryGirl.define do
  factory :share do
    association :expense, strategy: :build
    association :user, strategy: :build

    multiplier 1
    single_price_cents 6_00
  end
end
