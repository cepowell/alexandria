class CreateDocuments < ActiveRecord::Migration
  def up
    create_table :documents do |t|
      t.references :users, index: true, foreign_key: true
      t.references :collections, index: true, foreign_key: true
      t.string :name
      t.boolean :isPublished
      t.attachment :doc
      t.timestamps null: false
    end
  end
  
  def down
    drop_table 'documents'
  end
end
