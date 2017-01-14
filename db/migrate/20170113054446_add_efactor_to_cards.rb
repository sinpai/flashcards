class AddEfactorToCards < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :efactor, :float, default: '2.5'
  end
end
