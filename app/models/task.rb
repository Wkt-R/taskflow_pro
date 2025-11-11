class Task < ApplicationRecord
  # Associations
  belongs_to :project

  # Enums for status and priority - fixed syntax
  enum :status, {
    backlog: 0,
    todo: 1,
    in_progress: 2,
    review: 3,
    done: 4
  }, default: 1

  enum :priority, {
    low: 0,
    medium: 1,
    high: 2,
    urgent: 3
  }, default: 1

  validates :title, presence: true, length: { minimum: 2, maximum: 200 }
  validates :description, length: { maximum: 1000 }
  validates :status, inclusion: { in: statuses.keys }
  validates :priority, inclusion: { in: priorities.keys }

  scope :recent, -> { order(created_at: :desc) }
  scope :due_soon, -> { where("duedate <= ?", 3.days.from_now).where.not(status: "done").order(duedate: :asc) }
  scope :by_priority, ->(priority) { where(priority: priority) }
  scope :by_status, ->(status) { where(status: status) }

  def status_badge_color
    case status
    when "backlog" then "bg-gray-500"
    when "todo" then "bg-blue-500"
    when "in_progress" then "bg-yellow-500"
    when "review" then "bg-purple-500"
    when "done" then "bg-green-500"
    else "bg-gray-500"
    end
  end

  def priority_badge_color
    case priority
    when "low" then "bg-gray-500"
    when "medium" then "bg-blue-500"
    when "high" then "bg-orange-500"
    when "urgent" then "bg-red-500"
    else "bg-gray-500"
    end
  end

  def overdue?
    duedate.present? && duedate < Date.current && status != "done"
  end

  def due_soon?
    duedate.present? && duedate <= 3.days.from_now && duedate >= Date.current && status != "done"
  end

  def days_until_due
    return nil unless duedate.present?
    (duedate - Date.current).to_i
  end
end
