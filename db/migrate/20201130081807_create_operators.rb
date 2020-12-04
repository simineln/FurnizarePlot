class CreateOperators < ActiveRecord::Migration[6.0]
  def change
    create_table :operators do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
