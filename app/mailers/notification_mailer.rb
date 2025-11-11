class NotificationMailer < ApplicationMailer
  default from: "notifications@taskflowpro.com"

  def task_assigned(user, task)
    @user = user
    @task = task
    @project = task.project

    mail(
      to: @user.email,
      subject: "New task assigned: #{@task.title}"
    )
  end

  def task_due_reminder(user, task)
    @user = user
    @task = task
    @project = task.project

    mail(
      to: @user.email,
      subject: "Reminder: Task due soon - #{@task.title}"
    )
  end

  def project_report(user, project, report_data)
    @user = user
    @project = project
    @report_data = report_data

    mail(
      to: @user.email,
      subject: "Project Report: #{@project.name}"
    )
  end
end
