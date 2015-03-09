class CreateQuestionWatching < ActiveRecord::Migration
  def change
    create_table :question_watchings do |t|
      t.integer :question_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end

    add_index :question_watchings, [:question_id, :user_id], unique: true
  end
end
