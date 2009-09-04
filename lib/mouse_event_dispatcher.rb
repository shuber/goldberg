class MouseEventDispatcher
  
  def self.init(event_map = {}, attr_map = {})
    @@event_map = {
      Rubygame::MouseDownEvent => :mouse_down,
      Rubygame::MouseMotionEvent => :mouse_move,
      Rubygame::MouseUpEvent => :mouse_up
    }.update(event_map)
    
    @@attr_map = {
      :position => :pos,
      :button => :button,
      :buttons => :buttons
    }.update(attr_map)
    
    @@event_order = [:mouse_over, :mouse_move, :mouse_down, :mouse_up, :mouse_out]
    
    @@subscribers = {
      :object_mouse_down => {},
      :object_mouse_move => {},
      :object_mouse_out => {},
      :object_mouse_over => {},
      :object_mouse_up => {},
      :screen_mouse_down => {},
      :screen_mouse_move => {},
      :screen_mouse_up => {}
    }
    
    @@subscribers_count = 0
    
    @@last_screen_pos = nil
    
    @@params = {}
  end
  
  def self.add_event_properties_to_params(event)
    @@params[:screen_pos] = event.send(@@attr_map[:position])
    @@params[:button] = event.send(@@attr_map[:button]) rescue event.send(@@attr_map[:buttons])
    @@params[:screen_pos_change] = @@last_screen_pos.nil? ? [0,0] : [@@params[:screen_pos][0] - @@last_screen_pos[0], @@params[:screen_pos][1] - @@last_screen_pos[1]]
    @@params[:object_pos] = nil
  end
  
  def self.calculate_mouse_position_relative_to_object(object)
    return object.collide_point?(@@params[:screen_pos]) ? [@@params[:screen_pos][0] - object.position[0],@@params[:screen_pos][1] - object.position[1]] : nil
  end
  
  def self.dispatch(event)
    if @@subscribers_count
      if dispatcher_event = @@event_map[event.class]
        self.add_event_properties_to_params(event)
        self.send(dispatcher_event)
        
        @@last_screen_pos = @@params[:screen_pos].dup
      end
    end
  end
  
  def self.mouse_down
    @@subscribers[:screen_mouse_down].each do |object, listener|
      self.push(object, listener, @@params.merge({ :object_pos => self.calculate_mouse_position_relative_to_object(object) }))
    end
    
    @@subscribers[:object_mouse_down].each do |object, listener|
      pos = self.calculate_mouse_position_relative_to_object(object)
      self.push(object, listener, @@params.merge({ :object_pos => pos })) unless pos.nil?
    end
  end
  
  def self.mouse_move
    @@subscribers[:screen_mouse_move].each do |object, listener|
      self.push(object, listener, @@params.merge({ :object_pos => self.calculate_mouse_position_relative_to_object(object) }))
    end
    
    @@subscribers[:object_mouse_move].merge(@@subscribers[:object_mouse_over]).each do |object, listener|
      pos = self.calculate_mouse_position_relative_to_object(object)
      self.push(object, listener, @@params.merge({ :object_pos => pos })) unless pos.nil?
    end
    
    @@subscribers[:object_mouse_out].each do |object, listener|
      self.push(object, listener, @@params) if self.calculate_mouse_position_relative_to_object(object).nil?
    end
  end
  
  def self.mouse_up
    @@subscribers[:screen_mouse_up].each do |object, listener|
      self.push(object, listener, @@params.merge({ :object_pos => self.calculate_mouse_position_relative_to_object(object) }))
    end
    
    @@subscribers[:object_mouse_up].each do |object, listener|
      pos = self.calculate_mouse_position_relative_to_object(object)
      self.push(object, listener, @@params.merge({ :object_pos => pos })) unless pos.nil?
    end
  end
  
  def self.push(object, listener, args)
    object.send(listener, args) if object.respond_to? listener
  end
  
  def self.subscribe(event, object, listener = :push)
    @@subscribers[event][object] = listener
    @@subscribers_count += 1
  end
  
  def self.unsubscribe(event, object)
    @@subscribers[event].delete(object)
    @@subscribers_count -= 1
  end
  
end