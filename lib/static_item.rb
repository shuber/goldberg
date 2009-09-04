class StaticItem < Item
  
  attr_accessor :slope
  
  def initialize(args = {})
    attrs = {
      :resizeable => true,
      :slope => 0,
      :static => true
    }.update(args)
    super(attrs)
  end
  
end