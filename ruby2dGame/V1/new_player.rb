class Player
  #Player settings

  attr_accessor :hitbox, :move_x, :move_y, :x_pos, :y_pos, :sprite

  def initialize(x, y)
    @sprite = Sprite.new('img/map_v1.png', x: x*SIZE, y: y*SIZE, width: 32, height: 32, clip_width: 16, clip_height: 16, time: 100, animations: {down: 0..0, up: 1..1, right: 2..2, left: 3..3})
    @move_x = 0
    @move_y = 0
    @x_pos = x
    @y_pos = y
    @pulling = false
  end

  def update()
    if Window.frames % 10 == 0
      new_x = @x_pos + @move_x
      new_y = @y_pos + @move_y

    def move(x, y)
      $walls[@y_pos][@x_pos] = 0
      @x_pos = x
      @y_pos = y
      @sprite.x = @x_pos * SIZE
      @sprite.y = @y_pos * SIZE
      $walls[@y_pos][@x_pos] = 2
    end
    
    if $walls[new_y][new_x] == 0
      move(new_x, new_y)
    end
    end
  end
end

