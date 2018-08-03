require 'rails_helper'

RSpec.describe 'adding projects' do
  it 'allows a user to create a project with tasks' do
    visit new_projects_path
    fill_in 'Name', with: 'Project Runaway'
    fill_in 'Tasks', with: 'Tast 1:3\nTast 2:5'
    click_on('Create Project')
    visit projects_path
    expect(page).to have_content('Project Runaway')
    expect(page).to have_content('8')
  end
end
