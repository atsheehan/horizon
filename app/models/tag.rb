class Tag < ActiveRecord::Base
  has_many :lesson_tags
  has_many :lessons, through: :lesson_tags
end
