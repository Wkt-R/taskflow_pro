class TaskNotificationJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: :exponentially_longer, attempts: 3

  def perform(task_id, notification_type)
    Rails.logger.info "TaskNotificationJob started for task #{task_id}, type: #{notification_type}"

    task = Task.find_by(id: task_id)

    unless task
      Rails.logger.error "Task #{task_id} not found"
      return
    end

    user = task.project.user

    case notification_type
    when "assigned"
      Rails.logger.info "Sending task assigned email for task: #{task.title}"
      NotificationMailer.task_assigned(user, task).deliver_later

    when "due_soon"
      Rails.logger.info "Sending due soon reminder for task: #{task.title}"
      NotificationMailer.task_due_reminder(user, task).deliver_later

    else
      Rails.logger.warn "Unknown notification type: #{notification_type}"
    end

  rescue StandardError => e
    Rails.logger.error "TaskNotificationJob failed: #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.first(5).join("\n")
    raise
  end
end
