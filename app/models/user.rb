class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_many :projects, dependent: :destroy

  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    first_name[0] + last_name[0]
  end
end
