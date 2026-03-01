require 'ruby2d'

#Window settings 
set title: "Puzze game", 
fullscreen: false,
background: 'black',
width: 640,
height: 480,
viewport_width: 640,
viewport_height: 480

#Player settings
player_speed = 5



Square.new(
    x: 50, y:50,
    size:50,
    color: "white",
    z:10
)

# Define a square shape.
@player = Square.new(x: 10, y: 20, size: 25, color: 'blue')

# Define the initial speed (and direction).
@x_speed = 0
@y_speed = 0

# Define what happens when a specific key is pressed.
# Each keypress influences on the  movement along the x and y axis.
on :key_held do |event|
  if event.key == 'a'
    @x_speed = -player_speed
    @y_speed = 0
  elsif event.key == 'd'
    @x_speed = player_speed
    @y_speed = 0
  elsif event.key == 'w'
    @x_speed = 0
    @y_speed = -player_speed
  elsif event.key == 's'
    @x_speed = 0
    @y_speed = player_speed
  else
    @x_speed = 0
    @y_speed = 0
  end
end

update do
  @player.x += @x_speed
  @player.y += @y_speed
  if @player.x >= (get width:) || @player.x <= 0
    player_speed = 0
  end
end

show