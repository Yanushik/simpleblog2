class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :title
      t.string :body
      t.binary :image

      t.timestamps
    end
  end
end
