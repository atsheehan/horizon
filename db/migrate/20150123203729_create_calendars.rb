class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.string :name, null: false
      t.string :cid, null: false

      t.timestamps
    end
  end
end
