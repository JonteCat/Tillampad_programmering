class Box
  attr_accessor :x_pos, :y_pos, :sprite

  def initialize(x, y, clip_x=2, clip_y=1)
    @sprite = Sprite.new('img/map_v1.png', color: 'white', x: x*SIZE, y: y*SIZE, z: 10, width: 32, height: 32, clip_width: 16, clip_height: 16, clip_x: clip_x*(SIZE/SCALE), clip_y: clip_y*(SIZE/SCALE))
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

class Reflector < Box
  
  attr_reader :line, :angle

  def initialize(x, y, angle)
    if angle == 45
      super(x, y, 3, 1)
    elsif angle == 135
      super(x, y, 3, 2)
    elsif angle == 0
      super(x, y, 3, 3)
    end
    @line = Line.new(
      x1: x*SIZE , y1: y*SIZE,
      x2: x*SIZE+SIZE, y2: y*SIZE+SIZE,
      width: 4,
      color: 'white',
      z: 500
    )
    @angle = angle
  end

  def calculate_angle(x=@x_pos*SIZE, y=@y_pos*SIZE)
    @line.remove
    cx = x+SIZE/2
    cy = y+SIZE/2
    pi = Math::PI
    radius = SIZE/2


    # x1_point = cx*Math.cos(@angle*pi/180)*180/pi
    # y1_point = cy*Math.sin(@angle*pi/180)*180/pi
    # p @angle*(pi/180)
    
    # c = Circle.new(
    #   x: 150, y: 100,
    #   radius: 50,
    #   sectors: 32,
    #   color: 'white',
    #   z: 100
    # )


    # x1_point = c.x+c.radius*Math.cos(@angle*(pi/180))
    # y1_point = c.y+c.radius*Math.sin(@angle*(pi/180))
    # x2_point = c.x+c.radius*-Math.cos(@angle*(pi/180))
    # y2_point = c.y+c.radius*-Math.sin(@angle*(pi/180))

    x1_point = cx+radius*Math.cos(@angle*(pi/180))
    y1_point = cy+radius*Math.sin(@angle*(pi/180))
    x2_point = cx+radius*-Math.cos(@angle*(pi/180))
    y2_point = cy+radius*-Math.sin(@angle*(pi/180))

    @line.x1 = x1_point
    @line.y1 = y1_point
    @line.x2 = x2_point
    @line.y2 = y2_point

    # p "#{cx} #{cy}"
    # p "#{x1_point} #{y1_point}"
  end


end