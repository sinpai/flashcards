class AddDefaultPackToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :default_pack, :integer
  end
end
