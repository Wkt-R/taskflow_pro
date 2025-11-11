class TaskNotificationJob < ApplicationJob
  queue_as :default

  def perform(task_id, notification_type)
    Rails.logger.info "TaskNotificationJob started for task #{task_id}, type: #{notification_type}"
    task = Task.find_by(id: task_id)
    unless task
      Rails.logger.error "#{task_id} not found"
      return
    end

    case notification_type
    when "assigned"
      Rails.logger.info "Sending task email for task: #{task.title}"
      NotificationMailer.task_assigned(task.project.user, task).deliver_later
    when "due_soon"
      Rails.logger.info "Sending due soon reminder for task #{task.title}"
      NotificationMailer.task.task_due_reminder(task.project.user, task).delivery_later
    end
  end
end
