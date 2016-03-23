class CreateDocuments < ActiveRecord::Migration
  def up
    create_table :documents do |t|
      t.references :user, index: true, foreign_key: true
      t.references :collection, index: true, foreign_key: true
      t.string :name
      t.boolean :isPublished
      t.string :body
      t.timestamps null: false
    end
  end
  
  def down
    drop_table 'documents'
  end
end
