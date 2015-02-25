class AnswerComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :answer

  validates :body, presence: true
  validates :user, presence: true
  validates :answer, presence: true
end
