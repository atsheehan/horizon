class Tag < ActiveRecord::Base
  has_many :lesson_tags
  has_many :lessons, through: :lesson_tags

  validates :name, presence: true

  before_save :process_tag_name

  private

  def process_tag_name
    name.downcase!
    # replaces spaces and underscores with "-"
    name.gsub!(/[ _]/, "-")
    # removes all characters that are non letters, numbers, or dashes
    name.gsub!(/[^\w-]/, "")
  end
end
