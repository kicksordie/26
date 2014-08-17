FactoryGirl.define do
  factory :user do
    name "David O'Regan"
    email "david@example.com"
    password "password"
    password_confirmation "password"
  end
end