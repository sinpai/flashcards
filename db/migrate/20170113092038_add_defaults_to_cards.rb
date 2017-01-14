class AddDefaultsToCards < ActiveRecord::Migration[5.0]
  def change
    change_column :cards, :interval, :float, default: 1.0
    change_column :cards, :iteration, :integer, default: 1
  end
end
