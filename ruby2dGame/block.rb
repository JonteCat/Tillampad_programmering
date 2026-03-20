class Block
    
  attr_accessor 

  def initialize()
    @hitbox = Square.new(x: SIZE*4, y: SIZE*3, size: SIZE, color: 'blue', z: 500)
    
  end
end