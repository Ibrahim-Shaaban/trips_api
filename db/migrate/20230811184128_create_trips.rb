class CreateTrips < ActiveRecord::Migration[7.0]
  def change
    create_table :trips do |t|
      t.references :driver, null: false, foreign_key: true
      t.integer :status
      t.string :name

      t.timestamps
    end
  end
end
