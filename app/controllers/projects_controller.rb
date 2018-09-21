class ProjectsController < ApplicationController
  def index
    @projects = current_user.visible_projects
  end

  def new
    @project = Project.new
  end

  def create
    @action = CreatesProject.new(
        name: params[:project][:name],
        tasks_string: params[:project][:tasks],
        users: [current_user]
    )
    if  @action.create
      redirect_to projects_path
    else
      @project = @action.project
      render 'new'
    end
  end

  def show
    @project = Project.find(params[:id])
    unless current_user.can_view?(@project)
      redirect_to new_user_session_path
      return
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :due_date, :tasks, :users)
  end
end
