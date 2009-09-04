$:.push 'lib'
require 'init'



def run
  Rubygame.init
  Media.init
  MouseEventDispatcher.init
  
  #temp
  screen_size = [1400,900]
  
  screen = Rubygame::Screen.set_mode(screen_size)
  screen = Rubygame::Screen.new(screen_size, 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF, Rubygame::FULLSCREEN, Rubygame::ASYNCBLIT])
  
  screen_event_queue = Rubygame::EventQueue.new
  
  environment = Environment.new({ :size => screen_size })
  
  # (0..50).to_a.each do |i|
  #   environment.add_item TennisBall.new({ :position => [i*30, rand(200)]})
  # end
  # 
  # (0..25).to_a.each do |i|
  #   environment.add_item BowlingBall.new({ :position => [i*55, 200+rand(200)]})
  # end
  # 
  # (0..50).to_a.each do |i|
  #   environment.add_item TennisBall.new({ :position => [i*30, 400+rand(200)]})
  # end
  # 
  # (0..25).to_a.each do |i|
  #   environment.add_item BowlingBall.new({ :position => [i*55, 600+rand(200)]})
  # end
  
  # (0..50).to_a.each do |i|
  #   environment.add_item TennisBall.new({ :position => [rand(1200), rand(800)]})
  # end
  
  # (0..10).to_a.each do |i|
  #   environment.add_item BowlingBall.new({ :position => [rand(1200), rand(800)]})
  # end
  # 
  # (0..10).to_a.each do |i|
  #   environment.add_item BasketBall.new({ :position => [rand(1200), rand(800)]})
  # end
  
  # (0..10).to_a.each do |i|
  #   environment.add_item Wood.new({ :position => [rand(1200), rand(800)]})
  # end
  
  (0..50).to_a.each do |i|
    environment.add_item BasketBall.new({ :position => [rand(1300), rand(800)]})
  end
  
  iteration = 0
  loop do
    screen_event_queue.each do |event|
      MouseEventDispatcher.dispatch(event)
  		if event.class == Rubygame::QuitEvent
  		  return true
	    elsif event.class == Rubygame::KeyDownEvent
	      if event.key == Rubygame::K_SPACE
	        environment.toggle_gravity
	      elsif event.key == Rubygame::K_ESCAPE
	        Rubygame::Mixer.close_audio
	        return true
	      elsif !environment.gravity
	        if event.key == Rubygame::K_B
	          environment.add_item BasketBall.new({ :position => [rand(1350), rand(800)]})
	        elsif event.key == Rubygame::K_T
	          environment.add_item TennisBall.new({ :position => [rand(1350), rand(800)]})
	        elsif event.key == Rubygame::K_W
	          environment.add_item Wood.new({ :position => [rand(1350), rand(800)]})
	        elsif event.key == Rubygame::K_O
	          environment.add_item BowlingBall.new({ :position => [rand(1350), rand(800)]})
          end
	      end
	    end
  	end
    
    # Clear the screen
    screen.fill([69,168,223])
    
    # Need to make environment its own surface
    #environment.items.draw environment
    #environment.draw screen
    
    #draw the menus and whatnot
    
    params = {
      :iteration => iteration,
      :gravity => environment.gravity,
      :acceleration => environment.acceleration,
      :size => screen.size
    }
    
    environment.items.update params
    environment.items.draw screen
    
    #sleep(0.00) # need a ratio ... sleep vs item quantity.....hmm maybe not, seems to work fine with very little
  	screen.update
  	
  	iteration += 1
  end
end

run