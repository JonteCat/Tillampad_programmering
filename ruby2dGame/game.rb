require 'ruby2d'

#Window settings 
set title: "Puzzle game", 
fullscreen: false,
background: [0.5,0.5,0.5,0],
width: 800,
viewport_width: 640,
viewport_height: 480



set height: Window.width*3/4
  SIZE = Window.width/20


@move_xy = SIZE

def player_move(axis, move_axis, window_max, window_min)
  if axis < window_max || axis > window_min
    return axis = move_axis
  end
end

'''def player_outside_window(axis, window_max, window_min)
  if axis > window_max || axis < window_min
    axis = axis
  end
end'''

Square.new(
    x: 50, y:50,
    size:SIZE,
    color: "white",
    z:10
)

# Define a square shape.

class Player
  #Player settings

  attr_accessor :hitbox, :move_x, :move_y

  def initialize()
    @hitbox = Square.new(x: SIZE*4, y: SIZE*3, size: SIZE, color: 'blue', z: 500)
    @move_x = 0
    @move_y = 0
  end


  def update()
    if Window.frames % 10 == 0
      @hitbox.x += @move_x * SIZE
      @hitbox.y += @move_y * SIZE
    end
  end


  
end


@player = Player.new()

tick = 0

'''
on :key_held do |event|
  if tick >= 10
    if event.key == "a"
      @player.hitbox.x -= @move_xy
    elsif event.key == "d"
      @player.hitbox.x += @move_xy
    elsif event.key == "w"
      @player.hitbox.y -= @move_xy
    elsif event.key == "s"
      @player.hitbox.y += @move_xy
    elsif event.key == "b"
      exit

    end
    tick = 0
  end
  tick += 1
end

$key = nil
'''


on :key_held do |event|
  if @player.move_x == 0 && @player.move_y == 0
    case event.key
    when 'w'
      @player.move_y -= 1
    when 'a'
      @player.move_x -= 1
    when 's'
      @player.move_y += 1 
    when 'd'
      @player.move_x += 1
    end
  end
end

on :key_up do |event|
  if event.key == "w" && @player.move_y == -1 
    @player.move_y = 0
  elsif event.key == "s" && @player.move_y == 1
    @player.move_y = 0
  elsif event.key == "a" && @player.move_x == -1
    @player.move_x = 0
  elsif event.key == "d" && @player.move_x == 1
    @player.move_x = 0
  end
end

#Tile map

TILE_SIZE = SIZE
tile_map = [
  [1, 1, 1, 1],
  [1, 0, 0, 1],
  [1, 0, 0, 1],
  [1, 1, 1, 1]
]

y = 0

while y < tile_map.length
  row = tile_map[y]
  x = 0
  while x < row.length
    tile = row[x]
    if tile == 1
      Square.new(
        x: x*TILE_SIZE, y: y*TILE_SIZE,
        size: TILE_SIZE,
        color: "white",
      )
    end
    x += 1
  end
  y += 1
end

update do
  p "#{@player.move_x}, #{@player.move_y}"
  @player.update()
  '''
  player_outside_window(@player.x, 800, 0)
  player_outside_window(@player.y, 600, 0)'''
  player_move(@player.hitbox.x, @player.hitbox.x, 800, 0)
  player_move(@player.hitbox.y, @player.hitbox.y, 600, 0)
end

show

