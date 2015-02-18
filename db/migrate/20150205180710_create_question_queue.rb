class CreateQuestionQueue < ActiveRecord::Migration
  def change
    create_table :question_queues do |t|
      t.integer :question_id, null: false
      t.integer :team_id, null: false

      t.timestamps
    end
  end
end
