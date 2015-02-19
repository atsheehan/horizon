class AddNoShowCounterToQuestionQueues < ActiveRecord::Migration
  def change
    add_column :question_queues, :no_show_counter, :integer, default: 0
  end
end
