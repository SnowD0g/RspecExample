require 'rails_helper'
# Integration Test richiedono l'inclusione manuale delle fixtures

RSpec.describe 'adding projects', type: :feature do
  fixtures :all

  # negli Integration Test NON posso utilizzare Devise::TestHelper.sign_in
  before(:example) do
    sign_in users(:user)
  end

  it 'allows a user to create a project with tasks' do
    visit new_project_path
    fill_in 'Name', with: 'Project Runaway'
    fill_in 'Tasks', with: 'Tast 1:3\nTast 2:5'
    click_on('Create Project')
    visit projects_path
    @project = Project.find_by_name('Project Runaway')
    expect(page).to have_selector("#project_#{@project.id} .name", text: 'Project Runaway')
    expect(page).to have_selector("#project_#{@project.id} .total_size", text: '8')
  end
end
