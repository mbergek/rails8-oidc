class AddFacebookToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :fb_uid, :string
    add_column :users, :fb_email, :string
    add_column :users, :fb_first_name, :string
    add_column :users, :fb_last_name, :string
    add_column :users, :fb_name, :string
    add_column :users, :fb_image, :string
  end
end
