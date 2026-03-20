class Player
  #Player settings

  attr_accessor :hitbox, :move_x, :move_y, :x_pos, :y_pos

  def initialize()
    @hitbox = Square.new(x: SIZE*4, y: SIZE*3, size: SIZE, color: 'blue', z: 500)
    @move_x = 0
    @move_y = 0
    @x_pos = 0
    @y_pos = 0
  end

  def update()
    if Window.frames % 10 == 0
      new_x = @x_pos + @move_x
      new_y = @y_pos + @move_y
      if $tile_map[new_y][new_x] != 1
          @x_pos = new_x
          @y_pos = new_y
          @hitbox.x = @x_pos * SIZE
          @hitbox.y = @y_pos * SIZE
      end
    end
  end
end