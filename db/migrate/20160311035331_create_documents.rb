class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :users, index: true, foreign_key: true
      t.references :collections, index: true, foreign_key: true
      t.string :name
      t.boolean :isPublished
      t.attachment :doc
      t.timestamps null: false
    end
  end
end
