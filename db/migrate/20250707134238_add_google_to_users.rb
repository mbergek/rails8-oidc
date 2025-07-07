class AddGoogleToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :go_uid, :string
    add_column :users, :go_email, :string
    add_column :users, :go_first_name, :string
    add_column :users, :go_last_name, :string
    add_column :users, :go_name, :string
    add_column :users, :go_image, :text
  end
end
