FactoryBot.define do
  factory :user do
    name "Example User"
    email "user@example.com"
    password "foobar"
    password_confirmation "foobar"
    admin true
    activated true

    trait :other_user do
      name {Faker::Name.name}
      email {Faker::Internet.email}
      admin false
    end
  end
end
