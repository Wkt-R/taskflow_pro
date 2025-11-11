class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @projects = current_user.projects.recent.limit(5)

    @recent_tasks = Task.joins(:project)
                        .where(projects: { user_id: current_user.id })
                        .order(updated_at: :desc)
                        .limit(10)

    @due_soon_tasks = Task.joins(:project)
                          .where(projects: { user_id: current_user.id })
                          .where("tasks.duedate <= ?", 3.days.from_now)
                          .where.not(status: "done")
                          .order(duedate: :asc)
                          .limit(5)

    @overdue_tasks = Task.joins(:project)
                         .where(projects: { user_id: current_user.id })
                         .where("tasks.duedate < ?", Date.current)
                         .where.not(status: "done")
                         .order(duedate: :asc)

    @total_projects = current_user.projects.count
    @total_tasks = Task.joins(:project).where(projects: { user_id: current_user.id }).count
    @completed_tasks = Task.joins(:project).where(projects: { user_id: current_user.id }, status: "done").count
    @completion_rate = @total_tasks > 0 ? ((@completed_tasks.to_f / @total_tasks) * 100).round : 0

    @project_status_counts = current_user.projects.group(:status).count

    @task_status_counts = Task.joins(:project)
                              .where(projects: { user_id: current_user.id })
                              .group(:status)
                              .count

    @task_priority_counts = Task.joins(:project)
                                .where(projects: { user_id: current_user.id })
                                .group(:priority)
                                .count

    @recent_activity = Task.joins(:project)
                           .where(projects: { user_id: current_user.id })
                           .where("tasks.updated_at >= ?", 7.days.ago)
                           .select("tasks.*, projects.name as project_name")
                           .order("tasks.updated_at DESC")
                           .limit(15)
  end
end
