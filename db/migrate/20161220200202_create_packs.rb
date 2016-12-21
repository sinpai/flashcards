class CreatePacks < ActiveRecord::Migration[5.0]
  def change
    create_table :packs do |t|
      t.string :title
      t.timestamps
    end

    add_reference :cards, :pack, index: true, foreign_key: true
    add_reference :packs, :user, index: true, foreign_key: true
  end
end
