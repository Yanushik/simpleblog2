class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :comment, :string

    add_column :users, :profile_picture, :string

  end
end
