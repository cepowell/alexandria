class AddUserIdToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :user 
  end
end
