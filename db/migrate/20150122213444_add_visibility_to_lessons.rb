class AddVisibilityToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :visibility, :string, null: false, default: "public"
    add_index :lessons, :visibility
  end
end
