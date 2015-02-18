class CreateAnnouncementReceipts < ActiveRecord::Migration
  def up
    if table_exists?(:announcement_receipts)
      drop_table :announcement_receipts
    end

    create_table :announcement_receipts do |t|
      t.integer :user_id, null: false
      t.integer :announcement_id, null: false

      t.timestamps
    end
  end

  def down
    if table_exists?(:announcement_receipts)
      drop_table :announcement_receipts
    end
  end
end
