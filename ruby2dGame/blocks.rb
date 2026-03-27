class Block
    
  attr_accessor :rect, :x_pos, :y_pos, :pushable

  def initialize(x_pos, y_pos, color, pushable)
    @x_pos = x_pos
    @y_pos = y_pos
    @rect = Square.new(x: SIZE*x_pos, y: SIZE*y_pos, size: SIZE, color: color, z: 10)
    @pushable = pushable
  end

  def update(player_x, player_y)
    if Window.frames % 10 == 0
      
=begin new_x = @x_pos + player_x
      new_y = @y_pos + player_y
      if $tile_map[new_y][new_x] != 1
        $tile_map[@y_pos][@x_pos] = 0
        @x_pos = new_x
        @y_pos = new_y
        @rect.x = @x_pos * SIZE
        @rect.y = @y_pos * SIZE
        $tile_map[@y_pos][@x_pos] = 3
      end 
=end
    
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
    super(x_pos, y_pos, "blue", true)
    @x_dir = 0
    @y_dir = 0
    @pushable = false

  end


end

class Button < Block
    super(x_pos, y_pos, "purple", false)
end