# hacked by simon

# require 'ruby2d'

#Window settings 
# set title: "laser", 
# fullscreen: false,
# background: "black",
# width: 800,
# viewport_width: 512,
# resizable: true

# set height: Window.width*3/4,
# viewport_height: Window.viewport_width*3/4

$laser = Line.new(
  x1: 400, y1: 0,
  x2: 0, y2: 400,
  width: 4,
  color: 'lime',
  z: 20
)

$line = Line.new(
  x1: 0 , y1: 400,
  x2: 100, y2: 0,
  width: 4,
  color: 'white',
  z: 20
)

# $n = Line.new(
#   width: 2,
#   color: "white"
# )

$r = Line.new(
  width: 3,
  color: "white"
)

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

def line_line_detection

  x1 = $laser.x1
  x2 = $laser.x2
  y1 = $laser.y1
  y2 = $laser.y2
  # LINE X and Y COLLISIONS
  x3 = $line.x1
  x4 = $line.x2
  y3 = $line.y1
  y4 = $line.y2

  b = ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1))
  if b == 0
    return
  end
  uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / b.to_f
  uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / b.to_f

  if 0 < uA && uA < 1 && 0 < uB && uB < 1
    intersection_x = x1 + (uA * (x2-x1));
    intersection_y = y1 + (uA * (y2-y1));
    

    nx = -($line.y2-$line.y1)
    ny = ($line.x2-$line.x1)
    nx, ny = normalize(nx, ny)

    dx = $laser.x2 - $laser.x1
    dy = $laser.y2 - $laser.y1

    dot_prod = dot(dx, dy, nx, ny)

    rx = dx - 2 * dot_prod * nx
    ry = dy - 2 * dot_prod * ny

    # $n.x1 = intersection_x
    # $n.y1 = intersection_y

    # $n.x2 = intersection_x + nx*20
    # $n.y2 = intersection_y + ny*20


    $r.x1 = intersection_x
    $r.y1 = intersection_y

    $r.x2 = intersection_x + rx*100
    $r.y2 = intersection_y + ry*100
  else
    colliding = false
    $laser.color = "lime"
  end
  
  return colliding
end

on :mouse_down do |event|
  $laser.x1, $laser.y1 = event.x, event.y
end

update do 
  $laser.x2, $laser.y2 = Window.mouse_x, Window.mouse_y

  line_line_detection()
  
end

# show