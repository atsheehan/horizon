class AddVisibleToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :visible, :boolean, default: true
  end
end
