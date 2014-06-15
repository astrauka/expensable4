FactoryGirl.define do
  factory :user_group_relationship do
    association :user, strategy: :build
    association :group, strategy: :build
  end
end
