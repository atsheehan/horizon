class AddStatusAndExperienceEngineerToQuestionQueue < ActiveRecord::Migration
  def change
    add_column :question_queues, :status, :string, default: 'open'
    add_column :question_queues, :user_id, :integer
  end
end
