class CreateAnswerComments < ActiveRecord::Migration
  def change
    create_table :answer_comments do |t|
      t.text :body, null: false
      t.integer :answer_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
