require 'rails_helper'

RSpec.describe 'with users and roles' do
  def login(user)
    visit new_user_session_path
    fill_in('user_email', with: user.email)
    fill_in('user_password', with: user.password)
    click_button('Log in')
  end

  let(:user) { User.create(email: 'test@example.com', password: 'password') }

  it 'allow a logged user to view the project index page' do
    login(user)
    visit(projects_path)
    expect(current_path).to eq(projects_path)
  end

  it 'does not allow user to see project page if not logged in' do
    visit(projects_path)
    expect(current_path).to eq(new_user_session_path)
  end
end
