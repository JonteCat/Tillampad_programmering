require 'ruby2d'

#WINDOW SETTINGS
set title: "adventure of CAT", 
fps_cap: 65,
fullscreen: false,
background: "black",
width: 640,
viewport_width: 512,
resizable: true

set height: Window.width*3/4,
viewport_height: Window.viewport_width*3/4
SIZE = Window.viewport_width/16
SCALE = SIZE/16

require 'tmx'
require_relative 'box'
require_relative 'player.rb'
require_relative 'map.rb'
require_relative 'laser3.rb'


  # SIZE = 16

#ALL FILEPATHS TO .tmx MAPS
map_filepaths = {"map1" => "map_folder//room_1.tmx", "map2" => "map_folder//room_2.tmx", "map3" => "map_folder//room_3.tmx"}

#HASH WITH OBJECT ARRAYS
objects = {
  "buttons" => [],
  "boxes" => []
}

#LASER OBJECT
@laser = Laser.new(400, 0)

on :mouse_down do |event|
  @laser.line.x1, @laser.line.y1 = event.x, event.y
end

#DEFINES THE MAP AND BOUNDRIES
@map = Map.new(map_filepaths, objects)
@map.draw_all_maps(@map.define_tiles()[0], @map.define_tiles()[1])
$walls = @map.draw_map_type(@map.define_tiles()[0], @map.define_tiles()[1], @map.current_map["wall_map"])

#PLAYER START POSITION IN MAP 1
@player = Player.new(8, 5)

#PLAYER IN 2DARRAY
$walls[@player.y_pos][@player.x_pos] = 'P'

#MOVE LOGIC
on :key_held do |event|
  if @player.move_x == 0 && @player.move_y == 0
    p event.key
    case event.key
    when 'w', 'up'
      @player.move_y -= 1
      @player.sprite.play animation: :up, loop: true
    when 'a', 'left'
      @player.move_x -= 1
      @player.sprite.play animation: :left, loop: true
    when 's', 'down'
      @player.move_y += 1 
      @player.sprite.play animation: :down, loop: false
    when 'd', 'right'
      @player.move_x += 1
      @player.sprite.play animation: :right, loop: true
    when 'p', 'e' #&& 'a' #['w', 'a', 's', 'd'].include?(event.key)
      @player.pulling = true
    end
  end
end




# on :key_up do |event|
#   case event.key
        
#   when 'w', 'up', @player.move_y == -1 
#     @player.move_y = 0
#   when 's', 'down', @player.move_y == 1
#   end
# end

on :key_up do |event|
  if (event.key == "w" || event.key == 'up') && @player.move_y == -1 
    @player.move_y = 0
  elsif (event.key == "s" || event.key == 'down') && @player.move_y == 1
    @player.move_y = 0
  elsif (event.key == "a" || event.key == 'left') && @player.move_x == -1
    @player.move_x = 0
  elsif (event.key == "d" || event.key == 'right') && @player.move_x == 1
    @player.move_x = 0
  elsif (event.key == 'p' || event.key == 'e')
    @player.pulling = false
  end
end

update do
  @player.update()
  @map.update(@player, $objects["buttons"].each)
  @laser.update()
end

show