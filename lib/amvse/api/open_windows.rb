module Amvse
  class OpenWindow
    attr_accessor :id, :day_of_week, :open, :close
    
    def initialize(attributes={})
      self.id = attributes['id']
      self.day_of_week = attributes['day_of_week']
      self.open = attributes['open']
      self.close = attributes['close']
    end
    
    def serialize
      {
        'id': self.id,
        'day_of_week': self.day_of_week,
        'open': self.open,
        'close': self.close
      }
    end
    
  end
end