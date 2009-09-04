class BasketBall < Item
  
  def initialize(args = {})
    attrs = {
      :elasticity => 0.7,
      :size => [74,74],
      :terminal_velocity => 200
    }.update(args)
    super(attrs)
  end
  
end