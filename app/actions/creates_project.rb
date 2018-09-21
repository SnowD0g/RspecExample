class CreatesProject
  attr_reader :project, :users

  def initialize(options = {})
    @name = options[:name] || ''
    @tasks_string = options[:tasks_string] || ''
    @users = options[:users] || []
  end

  def build
    @project = Project.new(name: @name, tasks: convert_string_to_tasks, users: users)
  end

  def create
    build
    @project.save
  end

  def convert_string_to_tasks
    return [] if @tasks_string.empty?
    @tasks_string.split('\n').collect {|task_attributes| build_task(task_attributes) }
  end

  private

  def build_task(task_attributes)
    title, size = task_attributes.split(':')
    size ||= 1
    Task.new(title: title, size: size, user: users.first)
  end
end