class AddCalendarIdToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :calendar_id, :integer
  end
end
