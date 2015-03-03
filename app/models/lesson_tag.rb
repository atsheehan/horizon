class LessonTag < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :tag

  validates :lesson, presence: true
  validates :tag, presence: true
  validates :lesson, uniqueness: { scope: :tag }
end
