class DeleteUiDfromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :uid, :integer
  end
end
