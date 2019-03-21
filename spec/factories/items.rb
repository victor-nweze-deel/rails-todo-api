# frozen_string_literal: true

# Factory for generating fake records
FactoryBot.define do
  factory :item do
    name { Faker::Movies::StarWars.character }
    done { false }
    todo_id { nil }
  end
end
