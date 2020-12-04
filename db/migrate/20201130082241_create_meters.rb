class CreateMeters < ActiveRecord::Migration[6.0]
  def change
    create_table :meters do |t|
      t.string :name
      t.integer :number
      t.string :nlc
      t.integer :kt
      t.integer :operator_id
      t.integer :company_id

      t.timestamps
    end
  end
end
