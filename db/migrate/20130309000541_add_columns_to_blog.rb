class AddColumnsToBlog < ActiveRecord::Migration
  def change
    add_column :blogs, :Date_Created, :date

    add_column :blogs, :Date_Updated, :date

  end
end
