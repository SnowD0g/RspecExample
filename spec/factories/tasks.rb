FactoryBot.define do
  factory :task do
    association :project, name: 'Project for task', strategy: :build
  end
end
