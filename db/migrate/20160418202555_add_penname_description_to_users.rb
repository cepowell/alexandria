class AddPennameDescriptionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :penname, :string
    add_column :users, :description, :text
  end
end
