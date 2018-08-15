require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'can distinguish its completion state' do
    task = FactoryBot.build(:task)
    expect(task).not_to be_completed
    task.mark_completion
    expect(task).to be_completed
  end

  describe 'velocity' do
    let(:task) { FactoryBot.build(:task, size: 2) }
    it 'does not count an incomplete task toward velocity' do
      expect(task).not_to be_part_of_velocity
      expect(task.points_toward_velocity).to eq(0)
    end

    it 'does not count a long-ago task toward velocity' do
      task.mark_completion(6.months.ago)
      expect(task).not_to be_part_of_velocity
      expect(task.points_toward_velocity).to eq(0)
    end
  end
end
