class AddInvertMeter < ActiveRecord::Migration[6.0]
  def change
    add_column :meters, :inverted, :boolean
  end
end
