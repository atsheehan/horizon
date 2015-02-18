class RemoveTeamIdFromQuestionQueues < ActiveRecord::Migration
  def up
    remove_column :question_queues, :team_id
  end

  def down
    add_column :question_queues, :team_id, :integer, null: false
  end
end
