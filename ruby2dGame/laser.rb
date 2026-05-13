require 'ruby2d'

#Window settings 
set title: "laser", 
fullscreen: false,
background: "black",
width: 800,
viewport_width: 512,
resizable: true

set height: Window.width*3/4,
viewport_height: Window.viewport_width*3/4

TO_DEG = (180/Math::PI)

laser = Line.new(
  x1: 400, y1: 0,
  x2: 0, y2: 400,
  width: 4,
  color: 'lime',
  z: 20
)

# rect = Rectangle.new(
#   x: 300, y: 150,
#   width: 50,
#   height: 50
# )

line = Line.new(
  x1: 0 , y1: 400,
  x2: 100, y2: 0,
  width: 4,
  color: 'white',
  z: 20
)

normal = Line.new(
  x1: -(line.x2 - line.x1) , y1: line.y2 - line.y1,
  x2: line.x2 - line.x1 , y2: -(line.y2 - line.y1),
  width: 2,
  color: 'gray',
  z: 20
)

on :mouse_down do |event|
  # x and y coordinates of the mouse button event
  # puts event.x, event.y
  # puts Math.atan(laser.x2/laser.y2)*(180/Math::PI)
  
  laser.x1, laser.y1 = event.x, event.y
end

def line_line_detection(laser, line, normal)
    # LASER X and Y COLLISIONS
  x1 = laser.x1
  x2 = laser.x2
  y1 = laser.y1
  y2 = laser.y2
  # LINE X and Y COLLISIONS
  x3 = line.x1
  x4 = line.x2
  y3 = line.y1
  y4 = line.y2

  b = ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1))
  if b == 0
    return
  end

  uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / b.to_f
  uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / b.to_f

  # p "uA: #{uA} uB: #{uB}"

  if 0 < uA && uA < 1 && 0 < uB && uB < 1
    colliding = true
    laser.color = "blue"
    intersection_x = x1 + (uA * (x2-x1));
    intersection_y = y1 + (uA * (y2-y1));
    $inter_p.x = intersection_x
    $inter_p.y = intersection_y
    # puts "#{uA}, #{uB}"
    normal.x1 = intersection_x
    normal.y1 = intersection_y
    test = 100
    # normal.x1 = test
    # normal.y1 = test
    
    # normal.x2 = -(line.x2 - line.x1)
    # normal.y2 = (line.y2 - line.y1)
    
    # normal.x2 = -(line.x2 - line.x1 - test)
    # normal.y2 = (line.y2 - line.y1 + test)
    $norm_p.x = normal.x2
    $norm_p.y = normal.y2
    #puts "lx1: #{line.x1} lx2: #{line.x2} ly1: #{line.y1} ly2: #{line.y2} nx1: #{normal.x1} nx2: #{normal.x2} ny1: #{normal.y1} ny2: #{normal.y2}"
    # normal.x2 = line.x2 - line.x1 + (intersection_x - intersection_y)
    # normal.y2 = -(line.y2 - line.y1)
    # puts "#{(normal.y2 - normal.y1)/(normal.x2 - normal.x1)} #{(line.y2 - line.y1)/(line.x2 - line.x1)}"

    l_deg = Math.atan2(line.y2 - line.y1, line.x2 - line.x1)*TO_DEG + 90
    n_deg = Math.atan2(normal.y2 - normal.y1, normal.x2 - normal.x1)*TO_DEG + 90
    laser_deg = Math.atan2(laser.y2 - laser.y1, laser.x2 - laser.x1)*TO_DEG + 90
    # puts ("#{-laser_deg + l_deg} #{-Math.sin(-laser_deg + l_deg)*TO_DEG} #{Math.cos(l_deg - laser_deg)*TO_DEG}")
    # p laser_deg
    # normal.x2 = Math.sin(l_deg - laser_deg)*TO_DEG
    # normal.y2 = Math.cos(l_deg - laser_deg)*TO_DEG
    
    # n_dx = -(line.y2 - line.y1)

    # normal.x2 = n_dx + 

    # p "#{normal.x2} #{normal.y2}"

    v1 = 180 - laser_deg + l_deg
    # p v1
    v2 =  180 - v1

    normal.x2 = Math.cos(v1/TO_DEG)*100+200
    normal.y2 = Math.sin(v1/TO_DEG)*100+200
    p v2

    # p 180 - laser_deg + n_deg
    # puts "l_deg: #{l_deg} n_deg: #{n_deg}"
    # puts n_deg - l_deg
    # puts l_deg - laser_deg
    # puts l_deg + 90
  else
    colliding = false
    laser.color = "lime"
  end
  
  return colliding
end



$inter_p = Circle.new(
  x: 200, y: 175,
  radius: 2.5,
  sectors: 32,
  color: 'fuchsia',
  z: 500
)

$norm_p = Circle.new(
  x: 200, y: 175,
  radius: 2.5,
  sectors: 32,
  color: 'purple',
  z: 501
)

update do 

  # laser_deg = Math.atan2(laser.y2 - laser.y1, laser.x2 - laser.x1)*TO_DEG + 90

  # p laser_deg
  # p rect.width
  #p "m_x: #{Window.mouse_x} m_y: #{Window.mouse_y}"
  laser.x2, laser.y2 = Window.mouse_x, Window.mouse_y

  if line_line_detection(laser, line, normal)
    # p "hit"
  end
    # puts Math.sqrt((laser.x2**2) + (laser.y2**2))
  laser_length = Math.sqrt(((laser.x1 - laser.x2)**2) + (laser.y1 - laser.y2)**2)
  mouse_x, mouse_y = Window.mouse_x, Window.mouse_y
end
show