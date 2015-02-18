class AddAnswerCountToQuestions < ActiveRecord::Migration
  class Question < ActiveRecord::Base
    has_many :answers
  end

  class Answer < ActiveRecord::Base
    belongs_to :question, counter_cache: true
  end

  def up
    add_column :questions, :answers_count, :integer, null: false, default: 0

    Question.pluck(:id).each do |id|
      Question.reset_counters(id, :answers)
    end
  end

  def down
    remove_column :questions, :answers_count
  end
end
