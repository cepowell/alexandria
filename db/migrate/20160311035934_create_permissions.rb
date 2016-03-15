class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :users, index: true, foreign_key: true
      t.references :documents, index: true, foreign_key: true
      t.string :access

      t.timestamps null: false
    end
  end
end
