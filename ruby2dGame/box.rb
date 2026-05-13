class Box
  attr_accessor :x_pos, :y_pos, :sprite

  def initialize(x, y)
    @sprite = Sprite.new('img/map_v1.png', color: 'white', x: x*SIZE, y: y*SIZE, z: 10, width: 32, height: 32, clip_width: 16, clip_height: 16, clip_x: 2*(SIZE/SCALE), clip_y: 1*(SIZE/SCALE))
    @move_x = 0
    @move_y = 0
    @x_pos = x
    @y_pos = y
  end


  def move(x, y)
    $walls[@y_pos][@x_pos] = 0
    @x_pos = x
    @y_pos = y
    @sprite.x = @x_pos * SIZE
    @sprite.y = @y_pos * SIZE
    $walls[@y_pos][@x_pos] = 'B'
  end


end

class Button
  attr_accessor :x_pos, :y_pos, :sprite
  attr_reader :pushed
  
  def initialize(x, y)
    # super(x, y)
    @sprite = Sprite.new('img/map_v1.png', x: x*SIZE, y: y*SIZE, z: 0, width: 32, height: 32, clip_width: 16, clip_height: 16, clip_x: 0*(SIZE/SCALE), clip_y: 1*(SIZE/SCALE))
    @pushed = false
    @x_pos = x
    @y_pos = y
  end

  def pushed?(obj_x_pos, obj_y_pos)
    # p "#{obj_x_pos}, #{obj_y_pos} ||| #{@x_pos}, #{@y_pos}"
    if @x_pos == obj_x_pos && @y_pos == obj_y_pos
      @pushed = true
      p "pushed"
    else 
      @pushed = false
      # p "noooooo"
    end
  end

  def update()
    # p @pushed
    # @sprite.x = @x_pos * SIZE
    # @sprite.y = @y_pos * SIZE
  end
  
end