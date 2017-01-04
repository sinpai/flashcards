class ChangeDateTypeToTimestampInCards < ActiveRecord::Migration[5.0]
  def change
    change_column :cards, :review_date, :timestamp
  end
end
