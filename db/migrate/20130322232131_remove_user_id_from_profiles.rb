class RemoveUserIdFromProfiles < ActiveRecord::Migration
  def up
    remove_column :profiles, :user_id
      end

  def down
    add_column :profiles, :user_id, :integer
  end
end
