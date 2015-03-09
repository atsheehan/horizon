class AddIndicesToLessonTags < ActiveRecord::Migration
  def change
    add_index :lesson_tags, :tag_id
    add_index :lesson_tags, [:lesson_id, :tag_id], unique: true
  end
end
