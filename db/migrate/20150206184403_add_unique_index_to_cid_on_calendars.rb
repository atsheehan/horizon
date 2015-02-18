class AddUniqueIndexToCidOnCalendars < ActiveRecord::Migration
  def change
    add_index :calendars, :cid, unique: true
  end
end
