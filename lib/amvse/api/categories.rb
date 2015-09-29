module Amvse
  class Category
    attr_accessor :id, :name, :updated_at, :items
    
    def initialize(attributes={})
      self.id = attributes['id']
      self.name = attributes['name']
      self.updated_at = attributes['updated_at']
      self.items = (attributes['items'] || []).map{|item_json| Amvse::Item.new(item_json) }
    end
    
    def serialize
      {
        'id': self.id,
        'name': self.name,
        'updated_at': self.updated_at,
        'items': self.items.map{|item| item.serialize }
      }
    end
    
  end
end