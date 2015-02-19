class RemoveQuestionIdFromQuestionQueues < ActiveRecord::Migration
  def change
    remove_column :question_queues, :question_id
  end
end
