require 'ruby2d'

class Block
    
  attr_accessor :rect, :x_pos, :y_pos, :pushable, :passthrough

  def initialize(x_pos, y_pos, texture, pushable, passthrough)
    @x_pos = x_pos
    @y_pos = y_pos
    # @rect = Square.new(x: SIZE*x_pos, y: SIZE*y_pos, size: SIZE, color:, z: 10)
    # @rect = tileset.set_tile(texture, [{ x: SIZE*x_pos,  y: SIZE*y_pos }])
    # @rect = tileset.set_tile('blue', [{ x: 16*1,  y: 16*1 }])
    @pushable = pushable
    @passthrough = passthrough
  end

  def update(player_x, player_y)
    if Window.frames % 10 == 0
    
    
    end
  end

  def push(x_dir, y_dir)

    @x_pos += x_dir
    @y_pos += y_dir
    @rect.x = @x_pos * SIZE
    @rect.y = @y_pos * SIZE
    #$tile_map[@y_pos][@x_pos] = 3
  end

end

class Laser < Block
  
  def initialize(x_pos, y_pos, x_dir, y_dir) 
    super(x_pos, y_pos, "blue", false, true)
    @x_dir = 0
    @y_dir = 0

  end


end

class Button < Block

  attr_accessor :pressed

  def initialize(x_pos, y_pos, pressed)
    super(x_pos, y_pos, "purple", false, true)
    @pressed = pressed
  end

  def pressed()
        
    if get_block(@x_pos, @y_pos, Button) != Button
      @passthrough = false
      return true
    else 
      @passthrough = true
      return false
    end
    return false
  end
end

class Door < Block
    
  attr_accessor :go_to_next_room, :state

  def initialize(x_pos, y_pos, go_to_next_room, state)
    super(x_pos, y_pos, "black", false, false)
    @go_to_next_room = go_to_next_room
    @state = state
  end
  
end