class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  enum :status, {
    planning: 0,
    active: 1,
    completed: 2,
    archived: 3
  }

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validates :status, inclusion: { in: statuses.keys }

  scope :recent, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }
  scope :user_projects, ->(user) { where(user: user) }

  def status_badge_color
    case status
    when "planning" then "bg-blue-500"
    when "active" then "bg-green-500"
    when "completed" then "bg-gray-500"
    when "archived" then "bg-yellow-500"
    else "bg-gray-500"
    end
  end

  def days_since_created
    ((Time.current - created_at) / 1.day).floor
  end

  def tasks_count_by_status
    tasks.group(:status).count
  end

  def completed_tasks_count
    tasks.where(status: 4).count
  end

  def progress_percentage
    total_tasks = tasks.count
    return 0 if total_tasks.zero?
    (completed_tasks_count.to_f / total_tasks * 100).round
  end
end
