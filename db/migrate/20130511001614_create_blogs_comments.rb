class CreateBlogsComments < ActiveRecord::Migration
  def up
	create_table :blogs_comments, :id => false do |t|
	t.integer :blog_id, :null => false
	t.integer :comment_id, :null =>false
  end

  # Add index to speed up looking up the connection, and ensure
    # we only enrol a student into each course once
	add_index :blogs_comments, [:blog_id, :comment_id]
  end
  def down
	drop_table :blogs_comments
  end
end
