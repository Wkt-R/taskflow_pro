class ProjectExportJob < ApplicationJob
  queue_as :exports

  def perform(project_id, user_id)
    begin
      project = Project.find_by(id: project_id)
      user = User.find_by(id: user_id)

      report_data = generate_project_report(project)

      NotificationMailer.project_report(user, project, report_data).deliver_later

      store_report_in_redis(project, user, report_data)

    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error "ProjectExportJob: record not found - #{e.message}"
    rescue => e
      Rails.logger.error "ProjectExportJob failer: #{e.message}"
    raise e
    end
  end

  private

  def generate_project_report(project)
    tasks_by_status = project.tasks_count_by_status.transform_keys do |status_key|
      status_name = Task.statuses.key(status_key)
      status_name&.humanize || "Unknown Status (#{status_key})"
    end

    tasks_by_priority = project.tasks.group(:priority).count.transform_keys do |priority_key|
      priority_name = Task.priorities.key(priority_key)
      priority_name&.humanize || "Unknown Priority (#{priority_key})"
    end

    recent_tasks = project.tasks.recent.limit(5).map do |task|
      {
        title: task.title,
        status: task.status.humanize,
        priority: task.priority.humanize,
        duedate: task.duedate&.strftime("%Y-%m-%d")
      }
    end

    {
      project_name: project.name,
      project_status: project.status.humanize,
      total_tasks: project.tasks.count,
      completed_tasks: project.completed_tasks_count,
      progress_percentage: project.progress_percentage,
      tasks_by_status: tasks_by_status,
      tasks_by_priority: tasks_by_priority,
      recent_tasks: recent_tasks,
      report_generated_at: Time.current.strftime("%Y-%m-%d %H:%M:%S"),
      report_id: "report_#{project.id}_#{Time.current.to_i}"
    }
  end

  def store_report_in_redis(project, user, report_data)
    key = "project_report:#{project.id}:#{user.id}:#{Time.now.to_i}"

    Redis.current.setex(key, 1.hour, report_data.to_json)
    Rails.logger.info "Redis key created: #{key}"
  end
end
