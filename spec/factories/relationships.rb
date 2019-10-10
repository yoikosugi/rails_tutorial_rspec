FactoryBot.define do
  factory :relationship do
    follower_id 1
    sequence(:followed_id, 2) { |n| n }

    trait :passive do
      sequence(:follower_id, 2) { |n| n }
      followed_id 1
    end
  end
end
