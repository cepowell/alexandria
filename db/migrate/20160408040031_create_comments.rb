class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true, foreign_key: true
      t.references :document, index: true, foreign_key: true
      t.references :collection, index: true, foreign_key: true
      t.text :body
      t.integer :flagged

      t.timestamps null: false
    end
  end
end
