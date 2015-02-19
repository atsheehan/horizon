class AddQuestionQueueToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :question_queue_id, :integer
  end
end
