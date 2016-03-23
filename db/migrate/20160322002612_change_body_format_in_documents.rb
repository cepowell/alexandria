class ChangeBodyFormatInDocuments < ActiveRecord::Migration
  class Document < ActiveRecord::Base
  end
  
  def change
    change_column :documents, :body, :text
  end
end