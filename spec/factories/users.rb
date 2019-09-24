FactoryBot.define do
  factory :user do
    name "Example User"
    email "user@example.com"
    password "foobar"
    password_confirmation "foobar"
    admin true

    trait :archer do
      name "Sterling Archer"
      email "duchess@example.gov"
      admin false
    end

    trait :lana do
      name "Lana Kane"
      email "hands@example.gov"
      admin false
    end

    trait :malory do
      name "Malory Archer"
      email "boss@example.gov"
      admin false
    end

    trait :other_user do
      name Faker::Name.name
      email Faker::Internet.email
      admin false
    end
  end
end
