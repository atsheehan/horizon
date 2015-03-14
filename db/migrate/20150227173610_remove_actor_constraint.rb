class RemoveActorConstraint < ActiveRecord::Migration
  def up
    change_column :feed_items, :actor_id, :integer, null: true
  end

  def down
    change_column :feed_items, :actor_id, :integer, null: false
  end
end
