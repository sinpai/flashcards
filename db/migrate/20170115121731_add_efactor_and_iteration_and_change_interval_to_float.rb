class AddEfactorAndIterationAndChangeIntervalToFloat < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :efactor, :float, default: '2.5'
    change_column :cards, :interval, :float, default: 1.0
    add_column :cards, :iteration, :integer, default: 0
  end
end
