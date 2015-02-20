class AddColumnToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :vote_cache, :integer, default: 0
  end
end
