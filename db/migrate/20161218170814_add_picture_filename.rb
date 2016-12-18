class AddPictureFilename < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :picture, :string
  end
end
