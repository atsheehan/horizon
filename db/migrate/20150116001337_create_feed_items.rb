class CreateFeedItems < ActiveRecord::Migration
  def change
    create_table :feed_items do |t|
      t.integer :subject_id, null: false
      t.string :subject_type, null: false
      t.integer :recipient_id, null: false
      t.integer :actor_id, null: false
      t.string :verb, null: false

      t.timestamps
    end

    add_index :feed_items, [:subject_id, :subject_type]
    add_index :feed_items, :recipient_id
    add_index :feed_items, :actor_id
  end
end
