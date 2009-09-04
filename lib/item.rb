class Item
  
  include Resizeable
  include Draggable
  include Rubygame::Sprites::Sprite
  
  attr_accessor :changed, :draggable, :elasticity, :event_queue, :groups, :home_position, :image_name, :last_position, :moving, :next_velocity, :position, :resizeable, 
                :size, :sound_name, :static, :surface, :terminal_velocity, :thread, :velocity, :weight
  
  def add(group)
    self.groups << group
  end
  
  def initialize(args = {})
    attrs = {
      :changed => true,
      :draggable => true,
      :elasticity => 0.5,
      :image_name => "#{Inflector.underscore(self.class)}.png",
      :last_position => [0,0],
      :moving => true,
      :next_velocity => [0,0],
      :position => [0,0],
      :resizeable => false,
      :size => [50,50],
      :sound_name => "#{Inflector.underscore(self.class)}.wav",
      :static => false,
      :terminal_velocity => 30,
      :velocity => [0,0],
      :weight => 10
    }.update(args)
    attrs.each do |att, val|
      self.send "#{att}=".intern, val
    end
    self.event_queue = Rubygame::EventQueue.new
    self.groups = []
    self.draggable_init if self.draggable
  end
  
  def collide_point?(point)
    self.rect.collide_point?(point[0], point[1])
  end
  
  def enable_gravity(acceleration, size)
    if self.static # || !self.moving
      return true
    else
      self.next_velocity[1] = self.velocity[1] + acceleration
      self.next_velocity[1] = self.terminal_velocity if self.next_velocity[1] > self.terminal_velocity
      # if !(collisions = self.collide_group(self.groups.first.dup.delete(self))).empty?
      #   #collision test
      # end
      if self.velocity[1] >= 0 ################ GOING DOWN #################
        if self.position[1] + self.size[1] + self.next_velocity[1] >= size[1] #### BOUNCING ###
          self.last_position[1] = self.position[1]
          self.position[1] = size[1] - self.size[1]
          self.next_velocity[1] = (-1 * self.next_velocity[1] * self.elasticity).floor + 1
          Rubygame::Mixer.play(Media.load_sound("audio/#{self.sound_name}"), -1, 0) if self.moving rescue # no more channels
          if self.next_velocity[1] >= -3 # adjust?
            self.next_velocity[1] = 0
            self.velocity[1] = 0
            self.position[1] = size[1] - self.size[1]
            self.moving = false
          end
        elsif false
          # collisions
        else
          self.position[1] += self.next_velocity[1]
        end
      else ################ GOING UP ################
        if self.last_position[1] > 0
          self.position[1] = self.last_position[1]
          self.last_position[1] = 0
          self.next_velocity[1] -= acceleration
        else
          self.position[1] += self.next_velocity[1]
        end
      end
      self.velocity[1] = self.next_velocity[1]
    end
  end
  
  def changed?
    result = (self.last_position != self.position) || (self.position != self.home_position) || (self.changed)
    self.changed = false
  end
  
  def image
    @surface ||= Media.load_image("#{ITEM_IMAGES_PATH}/#{self.image_name}")
  end
  
  def rect
    @rect ||= Rubygame::Rect.new
    @rect.x = self.position[0]
    @rect.y = self.position[1]
    @rect.w = self.size[0]
    @rect.h = self.size[1]
    @rect
  end
  
  def update(args)
    if args[:iteration] != 0
      if args[:gravity]
        enable_gravity(args[:acceleration], args[:size])
      end
    end
  end
  
end