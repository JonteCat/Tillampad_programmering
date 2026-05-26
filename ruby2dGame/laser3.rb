# hacked by simon



class Laser
  LASER_COLOR = '#f54263' #'#8000FF' #'#e9c3fa'
  LASER_WIDTH = 8
  LASER_Z = 20
  attr_accessor :line, :x1, :y2
  def initialize(x1, y1)
    @line = Line.new(
      x1: x1, y1: y1,
      x2: 0, y2: 400,
      width: LASER_WIDTH,
      color: LASER_COLOR,
      z: LASER_Z
    )
    @x1 = x1
    @y1 = y1
    @new_laser = nil
    @reflected_line = nil
    @ref_array = []
    # @reflector = Reflector.new(5, 5)
  end

  



# $line = Line.new(
#   x1: 0 , y1: 400,
#   x2: 200, y2: 0,
#   width: 4,
#   color: 'white',
#   z: 500
# )

# puts $reflector
# $walls[@reflector.y_pos][@reflector.x_pos] = 'B'



# $n = Line.new(
#   width: 2,
#   color: "white"
# )



# $r = Line.new(
#   width: LASER_WIDTH,
#   color: LASER_COLOR,
#   z: LASER_Z
# )

# p @reflected_line

def length(x, y)
    return Math.sqrt(x**2+y**2)
end

def normalize(x, y)
  l = length(x, y)
    return [x/l, y/l]
end

def dot(x1, y1, x2, y2)
    return x1*x2 + y1*y2
end

def line_line_detection(laser, reflector)

  @x1 = laser.x1
  x2 = laser.x2
  @y1 = laser.y1
  y2 = laser.y2
  # LINE X and Y COLLISIONS
  x3 = reflector.x1
  x4 = reflector.x2
  y3 = reflector.y1
  y4 = reflector.y2

  b = ((y4-y3)*(x2-@x1) - (x4-x3)*(y2-@y1))
  if b == 0
    return
  end
  uA = ((x4-x3)*(@y1-y3) - (y4-y3)*(@x1-x3)) / b.to_f
  uB = ((x2-@x1)*(@y1-y3) - (y2-@y1)*(@x1-x3)) / b.to_f

  if 0 < uA && uA < 1 && 0 < uB && uB < 1
    intersection_x = @x1 + (uA * (x2-@x1));
    intersection_y = @y1 + (uA * (y2-@y1));
    

    nx = -(reflector.y2-reflector.y1)
    ny = (reflector.x2-reflector.x1)
    nx, ny = normalize(nx, ny)

    dx = laser.x2 - laser.x1
    dy = laser.y2 - laser.y1

    dot_prod = dot(dx, dy, nx, ny)

    rx = dx - 2 * dot_prod * nx
    ry = dy - 2 * dot_prod * ny

    # $r.x1 = intersection_x
    # $r.y1 = intersection_y
    # p @reflected_line
    @reflected_line.x1 = intersection_x
    @reflected_line.y1 = intersection_y
    laser.x2 = intersection_x
    laser.y2 = intersection_y

    # $r.x2 = intersection_x + rx*100
    # $r.y2 = intersection_y + ry*100
    @reflected_line.x2 = intersection_x + rx*100
    @reflected_line.y2 = intersection_y + ry*100
    
    colliding = true
  else
    colliding = false
  end
  return colliding
end


def draw_new_laser(reflector)
  if line_line_detection(@line, reflector) == true
    laser.color = LASER_COLOR
    @reflected_line.color = 'random'
    @reflected_line = @new_laser.line
    @reflected_line.add
  else 
    @line.color = "blue"
    if @reflected_line != nil
      @reflected_line.remove
    end
    @new_laser = Laser.new(0, 0)
    @reflected_line = @new_laser.line
    @reflected_line.remove
  end
end

  def update()
    @line.x2, @line.y2 = Window.mouse_x, Window.mouse_y
    $objects["boxes"].each do |ref, index|
      if ref.is_a?(Reflector)
        ref.calculate_angle()
        draw_new_laser(ref.line)
        # if line_line_detection(@line, ref.line) == true
        #   p ref.angle
        # end
        line_line_detection(@line, ref.line)
        @ref_array << ref.angle
        # if line_line_detection(@reflected_line, @ref_array[-1]) == true
        #   p "hello"
        # end

        # if line_line_detection(@reflected_line, @ref_array[-1]) == true
        #   # @reflected_line = @line
        #   p "hello"
        #   # line_line_detection(@line, ref.line)
        # end
        
        # p @ref_array
        
        # ref.line.x1 = ref.x_pos*SIZE
        # ref.line.y1 = ref.y_pos*SIZE
        # ref.line.x2 = ref.x_pos*SIZE+SIZE
        # ref.line.y2 = ref.y_pos*SIZE+SIZE
      end
      # line_line_detection(ref_array)
    end
    # line_line_detection(@reflector.line)
    # puts @reflector
    # $walls[@reflector.y_pos][@reflector.x_pos] = 'B'
    # p @reflector.y_pos
  end
end