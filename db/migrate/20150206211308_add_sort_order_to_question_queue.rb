class AddSortOrderToQuestionQueue < ActiveRecord::Migration
  def change
    add_column :question_queues, :sort_order, :integer, default: 0
  end
end
