FactoryBot.define do
  factory :user_post, class: Micropost do

    content { Faker::Lorem.sentence(5) }
    association :user, factory: :user

    trait :other_user_post do
      association :user, factory: [:user, :other_user]
    end
  end
end
