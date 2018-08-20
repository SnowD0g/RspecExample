require 'rails_helper'

# Le suite test con type: :controller NON utilizzano il file di routes
# le azioni del controller vengono chiamate direttamente passando method http e params
#
# Per verificare il comportamento dell'azione si verifica
# 1. il redirect
# 2. assegnamento di variabili @ nei controller

RSpec.describe ProjectsController, type: :controller do
  # sign_in è un helper offerto da Devise::TestHelper presente per il test dei controllore
  before(:example) do
    sign_in User.create!(email: 'rspec@example.com', password: 'password')
  end

  describe 'POST create' do
    let(:project_params) { { params: { project: { name: 'Runaway', tasks: 'Start something:2'} } } }
    let(:wrong_params) { { params: { project: { name: '', tasks: ''} } } }

    # Il test ha una dipendenza indiretta con il model Project,
    # per esempio modificando le validazioni nel model come side effect questo test può fallire.
    # Per testare in maniera isolata il controller diminuendo l'accoppiamento utilizziamo i test doubles
    it 'creates a project' do
      fake_action = instance_double(CreatesProject, create: true)
      expect(CreatesProject).to receive(:new)
        .with(name: project_params[:params][:project][:name], tasks_string: project_params[:params][:project][:tasks])
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
end
