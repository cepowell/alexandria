class AddBodyToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :body, :string
  end
end
