class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [ :show, :edit, :update, :destroy ]

  def index
    @projects = current_user.projects.recent
  end

  def show
    redirect_to projects_path, alert: "Project not found." unless @project
  end

  def new
    @project = current_user.projects.new
  end

  def edit
    redirect_to projects_path, alert: "Project not found." unless @project
  end

  def create
    @project = current_user.projects.new(project_params)

    if @project.save
      redirect_to "/projects/#{@project.id}", notice: "Project was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      redirect_to "/projects/#{@project.id}", notice: "Project was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_url, notice: "Project was successfully destroyed."
  end

  def export
    @project = current_user.projects.find_by(id: params[:id])

    if @project
      Rails.logger.info "Queueing ProjectExportJob for #{@project.id}"
        ProjectExportJob.perform_later(@project.id, current_user.id)
        redirect_to "/projects/#{@project.id}", notice: "Export started. You will receive an email with the report shortly"
    else
        redirect_to projects_path, alert: "Project not found"
    end
  end

  private

  def set_project
    @project = current_user.projects.find_by(id: params[:id])
    redirect_to projects_path, alert: "Project not found" unless @project
  end

  def project_params
    params.require(:project).permit(:name, :description, :status)
  end
end
