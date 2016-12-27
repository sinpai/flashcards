class RenameStatusToInterval < ActiveRecord::Migration[5.0]
  def change
    rename_column :cards, :status, :interval
  end
end
