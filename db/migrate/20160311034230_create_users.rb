class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first
      t.string :last
      t.string :email
      t.string :password
      t.string :password_digest
      t.string :provider
      t.boolean :emailOptOut
      t.timestamps null: false
    end
  end
end
