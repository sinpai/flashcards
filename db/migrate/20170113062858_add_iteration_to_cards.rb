class AddIterationToCards < ActiveRecord::Migration[5.0]
  def change
    change_column :cards, :interval, :float
    add_column :cards, :iteration, :integer
  end
end
