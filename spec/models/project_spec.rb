require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { FactoryBot.build(:project) }
  let(:task) { FactoryBot.build(:task) }

  it 'considers a project with no tasks to be done' do
   expect(project).to be_done
  end

  it 'knows that a project with an incomplete task is not done' do
    project.tasks << task
    expect(project).not_to be_done
  end

  it 'marks a project done if its tasks are completed' do
    project.tasks << task
    task.mark_completion
    expect(project).to be_done
  end

  it 'properly estimates a blank project' do
    expect(project.completed_velocity).to eq(0)
    expect(project.current_rate).to eq(0)
    expect(project.projected_days_remaining.nan?).to be_truthy
    expect(project).not_to be_on_schedule
  end

  # è diverso il setup, utilizzo un describe differente
  describe 'estimation' do
    let(:project) { FactoryBot.build(:project) }
    let(:newly_done) { FactoryBot.build(:task) }
    let(:old_done) { FactoryBot.build(:task) }
    let(:small_incomplete) { FactoryBot.build(:task) }
    let(:large_incomplete) { FactoryBot.build(:task) }

    before(:example) do
      allow(newly_done).to receive(:size).and_return(3)
      allow(newly_done).to receive(:completed_at).and_return(1.days.ago)

      allow(old_done).to receive(:size).and_return(2)
      allow(old_done).to receive(:completed_at).and_return(6.months.ago)

      allow(small_incomplete).to receive(:size).and_return(1)
      allow(large_incomplete).to receive(:size).and_return(4)

      project.tasks = [newly_done, old_done, small_incomplete, large_incomplete]
    end

    it 'can calculate total size' do
      expect(project.total_size).to eq(10)
    end

    it 'can calculate remaining size' do
      expect(project.remaining_size).to eq(5)
    end

    it 'knows its velocity' do
      expect(project.completed_velocity).to eq(3)
    end

    it 'knows its rate' do
      expect(project.current_rate).to eql(1.0 / 7)
    end

    it 'knows its pojected time remaining' do
      expect(project.projected_days_remaining).to eq(35)
    end

    it 'knows if it is on schedule' do
      project.due_date = 1.week.from_now
      expect(project).not_to be_on_schedule
      project.due_date = 3.months.from_now
      expect(project).to be_on_schedule
    end
  end
end
