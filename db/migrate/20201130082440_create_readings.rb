class CreateReadings < ActiveRecord::Migration[6.0]
  def change
    create_table :readings do |t|
      t.integer :meter_id
      t.datetime :date
      t.float :aec_p
      t.float :aec_m
      t.float :rec_p
      t.float :rec_m

      t.timestamps
    end
  end
end
