class BowlingBall < Item
  
  def initialize(args = {})
    attrs = {
      :elasticity => 0.4,
      :size => [50,50]
    }.update(args)
    super(attrs)
  end
  
end