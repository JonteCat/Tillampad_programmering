require 'ruby2d'
#require 'tmx'
require_relative 'player.rb'
require_relative 'blocks.rb'

#Window settings 
set title: "Puzzle game", 
fullscreen: false,
background: "#5e02a1",
width: 800,
viewport_width: 640,
viewport_height: 480

set height: Window.width*3/4
  SIZE = Window.width/20


@move_xy = SIZE

=begin def player_outside_window(axis, window_max, window_min)
  if axis > window_max || axis < window_min
    axis = axis
  end
end
=end

# Define a square shape.





$blocks = [] # [Block.new(6,7), Laser.new(2,2,1,0)]

# This function gets the type of block
# 
#
#
#Returns: the block
def get_block(x, y, type)
  $blocks.each do |block|
    if block.x_pos == x && block.y_pos == y && (type == block.class || type == nil)
      return block
    end
  end
  return nil
end


=begin on :key_held do |event|
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
=end



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
  elsif event.key == "f11"
    p "fullscreen"
    fs = get :fullscreen
    p fs
    set fullscreen: !fs
  end
end

#Tile map

TILE_SIZE = SIZE

# map = Tmx.load(myfilepath)

D = 4
L = 5
B = 6
$tile_map = [
  [1, 1, 1, 1, 1, 1, 1, D, D, 1, 1, 1, 1, 1, 1, 1,],
  [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,],
  [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,],
  [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,],
  [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,],
  [1, 0, 0, 0, 0, B, 0, 2, 0, 0, 0, 0, 0, 0, 0, 1,], #row 5 index 7 is player start pos
  [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,],
  [1, 0, 0, 0, 0, 0, 0, L, 0, 0, 3, 0, 0, 0, 0, 1,],
  [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,],
  [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,],
  [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,],
  [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,]
]

$tile_map.each_with_index do |row, y|
  row.each_with_index do |tile, x|
    if tile == 1
      $blocks << Block.new(x,y, "white", false, false)

    elsif tile == 2
      @player = Player.new(x, y)
    elsif tile == 3
      $blocks << Block.new(x, y, "red", true, false)

    elsif tile == D
      $blocks << Door.new(x, y, false, "closed")

    elsif tile == L
      $blocks << Laser.new(x, y, 0, 1)

    elsif tile == B
      $blocks << Button.new(x, y, false)
    end
    
  end
end



update do
=begin p "#{@player.move_x}, #{@player.move_y}" 
=end
  @player.update()
  # $blocks[0].update(@player.move_x, @player.move_y)
  #p $tile_map[5][7]
  #p $tile_map[5][8]
end

show