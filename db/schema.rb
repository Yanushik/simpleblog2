# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130511001614) do

  create_table "blogs", :force => true do |t|
    t.string   "title"
    t.string   "body"
    t.binary   "image"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "user_id"
    t.date     "Date_Created"
    t.date     "Date_Updated"
  end

  create_table "blogs_comments", :id => false, :force => true do |t|
    t.integer "blog_id",    :null => false
    t.integer "comment_id", :null => false
  end

  add_index "blogs_comments", ["blog_id", "comment_id"], :name => "index_blogs_comments_on_blog_id_and_comment_id"

  create_table "comments", :force => true do |t|
    t.string   "commentbody"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "profiles", :force => true do |t|
    t.string   "comment"
    t.binary   "profile_picture"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
    t.string   "username"
    t.string   "comment"
    t.string   "profile_picture"
  end

end
