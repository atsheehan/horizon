class RemovePositionFromLessons < ActiveRecord::Migration
  def up
    remove_column :lessons, :position
  end

  def down
    add_column :lessons, :position, :integer
    Lesson.update_all(position: 1)
    change_column :lessons, :position, :integer, null: false
  end
end
