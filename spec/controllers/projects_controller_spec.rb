require 'rails_helper'

# Le suite test con type: :controller NON utilizzano il file di routes
# le azioni del controller vengono chiamate direttamente passando method http e params
#
# Per verificare il comportamento dell'azione si verifica
# 1. il redirect
# 2. assegnamento di variabili @ nei controller

RSpec.describe ProjectsController, type: :controller do
  describe 'POST create' do
    let(:project_params) { { params: { project: { name: 'Runaway', tasks: 'Start something:2'} } } }
    let(:wrong_params) { { params: { project: { name: '', tasks: ''} } } }

    it 'creates a project' do
      post :create, project_params
      expect(response).to redirect_to(projects_path)
      expect(assigns(:action).project.name).to eq('Runaway')
    end

    it 'goes back to the form on failure' do
      post :create, wrong_params
      expect(response).to render_template(:new)
      expect(assigns(:project)).to be_present
    end
  end
end
