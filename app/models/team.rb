class Team < ActiveRecord::Base
  has_many :team_memberships, dependent: :destroy
  has_many :users, through: :team_memberships
  has_many :assignments, dependent: :destroy
  has_many :announcements, dependent: :destroy
  has_many :question_queues

  belongs_to :calendar

  validates :name, presence: true, uniqueness: true
end
