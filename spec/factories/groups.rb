FactoryGirl.define do
  sequence :name do |n|
    "Group #{n}"
  end

  factory :group do
    name
  end
end
