module Amvse
  class Menu
    attr_accessor :id, :name, :updated_at, :categories, :open_windows
    
    def initialize(attributes={})
      self.id = attributes['id']
      self.name = attributes['name']
      self.updated_at = attributes['updated_at']
      self.categories = (attributes['categories'] || []).map{|category_json| Amvse::Category.new(category_json) }
      self.open_windows = (attributes['open_windows'] || []).map{|open_window_json| Amvse::OpenWindow.new(open_window_json) }
    end
    
    def serialize
      data = {
        'id': self.id,
        'name': self.name,
        'updated_at': self.updated_at,
        'categories': [],
        'open_windows': []
      }
      data['categories'] = self.categories.map{|category| category.serialize }
      data['open_windows'] = self.open_windows.map{|open_window| open_window.serialize }
      data
    end
    
  end
end