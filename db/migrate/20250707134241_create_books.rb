class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.integer :user_id
      t.integer :author_id
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
