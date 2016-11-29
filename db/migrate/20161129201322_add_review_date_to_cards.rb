class AddReviewDateToCards < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :review_date, :date
  end
end
