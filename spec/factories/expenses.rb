FactoryGirl.define do
  factory :expense do
    association :group, strategy: :build
    association :creator, factory: :user, strategy: :build
    association :payer, factory: :user, strategy: :build

    description "Food"
    spent_cents 12_00
  end
end
