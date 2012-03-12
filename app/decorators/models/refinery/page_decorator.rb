Refinery::Page.class_eval do 
  searchable do
    text :title, :boost => 5.0
    text :parts do 
      parts.collect(&:body).join(' ')
    end
    boolean :published do 
      live?
    end
    integer :id
  end
  
  handle_asynchronously :solr_index
end