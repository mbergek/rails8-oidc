class AddRolesMaskToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :roles_mask, :integer
  end
end
