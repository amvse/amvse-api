module Amvse
  class Item
    attr_accessor :id, :name, :updated_at, :data
    
    def initialize(attributes={})
      self.id = attributes['id']
      self.name = attributes['name']
      self.updated_at = attributes['updated_at']
      self.data = attributes['data']
    end
    
    def serialize
      {
        'id': self.id,
        'name': self.name,
        'updated_at': self.updated_at,
        'data': self.data
      }
    end
    
  end
end