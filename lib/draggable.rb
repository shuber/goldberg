module Draggable
  
  attr_accessor :drag_enabled, :dragging, :drop_enabled, :home_position, :last_position, :position
  
  def draggable_init
    MouseEventDispatcher.subscribe(:object_mouse_over, self, :mouse_over)
    self.drag_enabled = true
    self.dragging = false
    self.drop_enabled = true
  end
  
  def drag_start(args)
    MouseEventDispatcher.unsubscribe(:object_mouse_down, self)
    MouseEventDispatcher.subscribe(:screen_mouse_move, self, :drag_move)
    MouseEventDispatcher.subscribe(:screen_mouse_up, self, :drag_drop)
    self.dragging = true
    self.home_position = self.position.dup
    self.last_position = self.position.dup
  end
  
  def drag_move(args)
    new_pos = args[:screen_pos_change].dup
    if new_pos != self.last_position
      self.position[0] += new_pos[0]
      self.position[1] += new_pos[1]
      self.last_position = self.position.dup
    end
  end
  
  def drag_drop(args)
    MouseEventDispatcher.unsubscribe(:screen_mouse_up, self)
    MouseEventDispatcher.unsubscribe(:screen_mouse_move, self)
    MouseEventDispatcher.subscribe(:object_mouse_down, self, :drag_start)
    self.dragging = false
    if self.drop_enabled
      self.home_position = self.position.dup
    else
      self.position = self.home_position.dup
    end
  end
  
  def mouse_out(args)
    MouseEventDispatcher.unsubscribe(:object_mouse_down, self)
    MouseEventDispatcher.unsubscribe(:object_mouse_out, self)
    MouseEventDispatcher.subscribe(:object_mouse_over, self, :mouse_over)
    # dim
  end
  
  def mouse_over(args)
    MouseEventDispatcher.unsubscribe(:object_mouse_over, self)
    MouseEventDispatcher.subscribe(:object_mouse_out, self, :mouse_out)
    MouseEventDispatcher.subscribe(:object_mouse_down, self, :drag_start)
    # highlight
  end
  
end