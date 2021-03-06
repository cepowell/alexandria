class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.references :user, index: true, foreign_key: true
      t.boolean :isPublished
      t.string :name
      t.timestamps null: false
    end
  end
end
