class ChangeBodyFormatInDocuments < ActiveRecord::Migration
  class Document < ActiveRecord::Base
  end
  
  def change
    change_column :documents, :body, :text
    Document.reset_column_information
    Document.all.each do |d|
      d.update_attributes!(:flag => false)
    end
  end
end