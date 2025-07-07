class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :book_id
      t.text :comment
      t.integer :rating

      t.timestamps
    end
  end
end
