class CreateVote < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :votable_id, null: false
      t.integer :user_id, null: false
      t.string :votable_type, null: false
      t.integer :score, default: 0

      t.timestamps
    end
  end
end
