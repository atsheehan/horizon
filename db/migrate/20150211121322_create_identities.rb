class CreateIdentities < ActiveRecord::Migration
  class User < ActiveRecord::Base
    has_many :identities
  end

  class Identity < ActiveRecord::Base
    belongs_to :user
  end

  def up
    create_table :identities do |t|
      t.string :uid, null: false
      t.string :provider, null: false
      t.integer :user_id, null: false

      t.timestamps
    end

    Identity.reset_column_information

    Identity.transaction do
      User.find_each do |u|
        if u.identities.count == 0
          u.identities.create! do |identity|
            identity.provider = u.provider
            identity.uid = u.uid
          end
        end
      end
    end

    remove_column :users, :provider
    remove_column :users, :uid

    add_index :identities, [:uid, :provider], unique: true
    add_index :identities, :user_id
  end

  def down
    add_column :users, :provider, :string
    add_column :users, :uid, :string

    User.reset_column_information

    Identity.find_each do |identity|
      identity.user.provider ||= identity.provider
      identity.user.uid ||= identity.uid
      identity.user.save!
    end

    change_column :users, :provider, :string, null: false
    change_column :users, :provider, :string, null: false

    add_index :users, [:uid, :provider]

    drop_table :identities
  end
end
