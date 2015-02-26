class CreateLessonTags < ActiveRecord::Migration
  def change
    create_table :lesson_tags do |t|
      t.belongs_to :lesson, null: false
      t.belongs_to :tag, null: false
    end
  end
end
