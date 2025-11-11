class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_task, only: [ :edit, :update, :destroy ]

  def index
    @tasks = @project.tasks.recent
  end

  def new
    @task = @project.tasks.new
  end

  def create
    @task = @project.tasks.new(task_params)

    if @task.save
      TaskNotificationJob.perform_later(@task.id, "assigned")

      redirect_to "/projects/#{@project.id}", notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      if task_params[:duedate].present? && @task.due_soon?
        TaskNotificationJob.perform_later(@task.id, "due_soon")
      end

      if request.xhr? || request.format.json?
        head :ok
      else
        redirect_to "/projects/#{@project.id}", notice: "Task successfully updated"
      end
    else
      if request.xhr? || request.format.json?
        render json: { errors: @task.errors }, status: :unprocessable_entity
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @task.destroy
    redirect_to "/projects/#{@project.id}", notice: "Taks was successfully destroyed."
  end

  private

  def set_project
    @project = current_user.projects.find_by(id: params[:project_id])
    redirect_to projects_path, alert: "Project not found." unless @project
  end

  def set_task
    @task = @project.tasks.find_by(id: params[:id])
    redirect_to "/projects/#{@project.id}", alert: "Task not found." unless @task
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :priority, :duedate)
  end
end
