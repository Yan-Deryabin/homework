class CreateRatings < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  def change
    create_table :ratings do |t|
      t.belongs_to :product
      t.float :avg_rating
      t.integer :rate_count
      t.date :analyse_date
    end

    add_index :ratings, :analyse_date, algorithm: :concurrently
    add_index :ratings, %i[ product_id analyse_date ], unique: true, algorithm: :concurrently
  end
end
