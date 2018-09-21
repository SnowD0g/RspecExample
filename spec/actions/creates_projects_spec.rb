require 'rails_helper'

RSpec.describe CreatesProject do
  fixtures :all
  let(:creator) { CreatesProject.new(name: 'Project Runaway', users: [users(:user)]) }

  it 'creates a project given a name' do
    creator.create
    expect(creator.project.name).to eq('Project Runaway')
  end

  describe 'task string parsing' do
    let(:creator) { CreatesProject.new(name: 'Project Runaway', tasks_string: task_string, users: [users(:user)]) }
    let(:tasks) { creator.convert_string_to_tasks}

    describe 'with an empty string' do
      let(:task_string) { '' }
      specify { expect(tasks.size).to eq(0) }
    end

    describe 'with a single string' do
      let(:task_string) { 'Start Things' }
      specify { expect(tasks.size).to eq(1) }
      specify { expect(tasks.map(&:title)).to eq(['Start Things']) }
      specify { expect(tasks.map(&:size)).to eq([1]) }
    end

    describe 'with a single string and a size' do
      let(:task_string) { 'Start Things:3' }
      specify { expect(tasks.size).to eq(1) }
      specify { expect(tasks.map(&:title)).to eq(['Start Things']) }
      specify { expect(tasks.map(&:size)).to eq([3]) }
    end

    describe 'with multiple tasks' do
      let(:task_string) { 'Start Things:3\nEnd things:2' }
      specify { expect(tasks.size).to eq(2) }
      specify { expect(tasks.map(&:title)).to eq(['Start Things', 'End things']) }
      specify { expect(tasks.map(&:size)).to eq([3, 2]) }
    end

    describe 'attaching tasks to the project' do
      let(:task_string) { 'Start Things:3\nEnd things:2' }
      it 'saves the project and tasks' do
        creator.create
        expect(creator.project.tasks.size).to eq(2)
        expect(creator.project).to be_persisted
      end
    end
  end

  it 'adds users to the projects' do
    user = User.new
    creator = CreatesProject.new(name: 'Project Runaway', users: [user])
    creator.build
    expect(creator.project.users).to eq([user])
  end
end
