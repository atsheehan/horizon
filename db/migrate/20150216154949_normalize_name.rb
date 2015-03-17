class NormalizeName < ActiveRecord::Migration
  class User < ActiveRecord::Base; end
  def up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

    User.reset_column_information

    User.find_each do |user|
      split_name = user.name.split(" ", 2)
      user.first_name = split_name[0]
      user.last_name = split_name[1]
      user.save!
    end

    remove_column :users, :name
  end

  def down
    add_column :users, :name, :string

    User.find_each do |user|
      user.name = [user.first_name, user.last_name].join(" ")
      user.save!
    end

    remove_column :users, :last_name
    remove_column :users, :first_name

    change_column :users, :name, :string, null: false
  end
end
