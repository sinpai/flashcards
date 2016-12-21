# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pack do
    title { 'testword'.concat rand(900).to_s }
  end
end
