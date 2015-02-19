class AddColumnAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :vote_cache, :integer, default: 0
  end
end
