require 'rails_helper'

# Le suite test con type: :controller NON utilizzano il file di routes
# le azioni del controller vengono chiamate direttamente passando method http e params
#
# Per verificare il comportamento dell'azione si verifica
# 1. il redirect
# 2. assegnamento di variabili @ nei controller

RSpec.describe ProjectsController, type: :controller do
  # sign_in è un helper offerto da Devise::TestHelper presente per il test dei controllore
  let(:user) { User.create!(email: 'rspec@example.com', password: 'password') }

  before(:example) do
    sign_in user
  end

  describe 'POST create' do
    let(:project_params) { { params: { project: { name: 'Ruusersnaway', tasks: 'Start something:2'} } } }
    let(:wrong_params) { { params: { project: { name: '', tasks: ''} } } }

    # Il test ha una dipendenza indiretta con il model Project,
    # per esempio modificando le validazioni nel model come side effect questo test può fallire.
    # Per testare in maniera isolata il controller diminuendo l'accoppiamento utilizziamo i test doubles
    it 'creates a project' do
      fake_action = instance_double(CreatesProject, create: true)
      expect(CreatesProject).to receive(:new)
        .with(name: project_params[:params][:project][:name],
              tasks_string: project_params[:params][:project][:tasks], users: [user])
        .and_return(fake_action)

      post :create, project_params
      expect(response).to redirect_to(projects_path)
      expect(assigns(:action)).not_to be_nil
    end

    it 'goes back to the form on failure' do
      post :create, wrong_params
      expect(response).to render_template(:new)
      expect(assigns(:project)).to be_present
    end
  end

  describe 'GET index' do
    it 'displays all projects correctly' do
      user = User.new
      project = Project.new(name: 'Project Super Test')
      allow(controller).to receive(:current_user).and_return(user)
      allow(user).to receive(:visible_projects).and_return([project])
      get :index
      expect(assigns(:projects)).to eq([project])
    end
  end

  describe 'GET show' do
    let(:project) { Project.create(name: 'Project Runway') }

    it 'allow a user who is part of the project to see the project' do
      allow(controller.current_user).to receive(:can_view?).and_return(true)
      get :show, { params: { id: project.id } }
      expect(response).to render_template(:show)
    end

    it 'does not allow a user who is not part of the project to see the project' do
      allow(controller.current_user).to receive(:can_view?).and_return(false)
      get :show, { params: { id: project.id } }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'does not allow a user who is not part of the project to see the project' do
      allow(controller.current_user).to receive(:can_view?).and_return(false)
      get :show, { params: { id: project.id } }
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
