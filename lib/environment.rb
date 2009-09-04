class Environment
  
  include Rubygame::Sprites::Sprite
  
  attr_accessor :acceleration, :gravity, :items, :position, :size
  
  def initialize(args = {})
    attrs = {
      :acceleration => 1, # Velocity increases 1px/iteration
      :gravity => false, # gravity is "off"
      :position => [0,0],
      :size => [500,500]
    }.update(args)
    attrs.each do |att, val|
      self.send "#{att}=", val
    end
    self.items = Rubygame::Sprites::Group.new
  end
  
  def add_item(item)
    self.items.push item
  end
  
  def disable_gravity
    self.gravity = false
    self.items.each do |item|
      item.moving = false
      item.position = item.home_position.dup
      item.next_velocity = [0,0]
      item.velocity = [0,0]
      item.changed = true
    end
  end
  
  def enable_gravity
    self.gravity = true
    self.items.each do |item|
      item.home_position = item.position.dup
      item.moving = true
    end
  end
  
  def list_items
    self.items.each do |item|
      puts item.class
    end
  end
  
  def remove_item(item)
    self.items.delete item
  end
  
  def surface
    #
  end
  
  def toggle_gravity
    if self.gravity
      disable_gravity
    else
      enable_gravity
    end
  end
  
end