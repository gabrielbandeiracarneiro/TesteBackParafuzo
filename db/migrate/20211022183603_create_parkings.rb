class CreateParkings < ActiveRecord::Migration[6.1]
  def change
    create_table :parkings do |t|
      t.string :plate
      t.string :reservation
      t.string :time
      t.boolean :paid
      t.boolean :left
      t.datetime :entryDate
      t.datetime :paidDate
      t.datetime :exitDate

      t.timestamps
    end
    add_index :parkings, :plate
  end
end
