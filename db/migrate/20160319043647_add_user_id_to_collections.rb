class AddUserIdToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :user, :id
  end
end
