class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :address
      t.text :description
      t.integer :operator_id

      t.timestamps
    end
  end
end