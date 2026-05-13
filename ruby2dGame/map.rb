require 'ruby2d'

class Map
 attr_accessor :current_map, :map_file_path

  def initialize(filepaths, objects)
    @map_filepath = filepaths
    @current_map = map_type(Tmx.load(filepaths["map1"]))
    $objects = objects
    @room = @map_filepath.keys
    @current_room = "map1"
    @frames = 0
    @current_time = 0
    @old_time = 0
    @wait_time = 5000
    @transition = Image.new("img/loading_screen.png", x: 0, y: 0, width: Window.viewport_width, height: Window.viewport_height, z: 500)
    # @transition = Sprite.new("img/loading_screen_tilesheet.png", x: 0, y: 0, width: Window.viewport_width, height: Window.viewport_height, clip_height: 261, clip_width: 355, z: 500)

    @loading_zone = Sprite.new('img/textures_v2.png', x: 7*SIZE, y: 0*SIZE, z: 10, width: 32, height: 32, clip_width: 16, clip_height: 16, clip_y: 3*16 ,time: 500, default: 4, animations: {open: 4..7, opened_frame: 7..7})
    @loading_zone_accessible = false



  end

  # This function retuns a string of the current map number
  #
  # @param argument1 [Integer] 
  # @return [String]
  #
  # @example
  #  next_room(1) => "map1"
  #  next_room(2) => "map2"
  #  next_room(1337) => "map1337"
  #
  # @author Jonathan Wiklund
  def next_room(number)
    array = ["map", number]
    array[1] += 1
    array[1] = array[1].to_s
    return concatenate(array[0], array[1])
  end

  # This function adds two strings into one long string
  #
  # @param argument1 [String] the first string
  # @param argument2 [String] the second string
  # @return [String] the added strings
  #
  # @example
  #  concatenate("hello", "world") => "helloworld"
  #  concatenate("", "") => ""
  #  concatenate("13", "37") => "1337"
  #
  # @author Jonathan Wiklund
  def concatenate(string1, string2)
    return string1 + string2
  end

def door_handler(buttons)
  # Sprite rotation
    if 0 < @loading_zone.y/SIZE && $walls[0].length/2 < @loading_zone.x/SIZE
      @loading_zone.rotate = 90 
    elsif 0 < @loading_zone.y/SIZE && @loading_zone.x/SIZE < $walls[0].length/2
      @loading_zone.rotate = 270
    elsif $walls.length/2 < @loading_zone.y/SIZE 
      @loading_zone.rotate = 180
    else 
      @loading_zone.rotate = 0
    end
   
    all_buttons_pressed = true

    buttons.each do |button| 
      if button.pushed == false
        all_buttons_pressed = false
        break
      else
        all_buttons_pressed = true
      end
    end

    if all_buttons_pressed == true && @loading_zone_accessible == false

      while @current_time - @old_time > @wait_time
        @loading_zone.play animation: :open, loop: false, flip: nil
        
        p @current_time - @old_time
        @old_time = @current_time
      end

      @loading_zone.play animation: :opened_frame, loop: true
      $walls[@loading_zone.y/SIZE][@loading_zone.x/SIZE] = 0
      @loading_zone_accessible = true
    elsif all_buttons_pressed == false

      @loading_zone.stop
      $walls[@loading_zone.y/SIZE][@loading_zone.x/SIZE] = -1
      @loading_zone_accessible = false
    end

end

  def map_type(map)
    floor_map = nil
    wall_map = nil
    object_map = nil
    map.layers.each_with_index do |layer, index|
      if layer.name == "Floor layer"
        floor_map = integrate_map(layer.data, layer.width)
      elsif layer.name == "Wall layer"
        wall_map = integrate_map(layer.data, layer.width)
      elsif layer.name == "Interact layer"
        object_map = integrate_map(layer.data, layer.width)
      end
    end
    return {"floor_map" => floor_map, "wall_map" => wall_map, "object_map" => object_map}
  end

def integrate_map(layer_data, width)
    layer_map = []
    i = 0
    while i < layer_data.length
  
      array = []
      row_end = i + width 
      while i < row_end
        array << layer_data[i]
        i+=1
      end
      layer_map << array
    end
    return layer_map
end

# This function defines all the tiles and returns an array with ids and a tileset in one array
#
# @return [Array] array with id array and tileset
#
# @author Jonathan Wiklund
def define_tiles()
  tileset = Tileset.new(
    'img/textures_v2.png',
    tile_width: 16,
    tile_height: 16,
    padding: 0,
    spacing: 0,
    scale: SCALE
  )
  y = 0
  id = 0
  id_array = []
  while y <= 5
    x = 0
    while x <= 9
      tileset.define_tile(id, x, y)
      x+=1
      id+=1
      id_array << id
    end
    y+=1
  end
  return [id_array, tileset]
end

def draw_map_type(id, tileset, map_type)
  map_type.each_with_index do |row, y|
    row.each_with_index do |tile, x|
      if id.include?(tile)
        if tile == 11
          $objects["buttons"] << Button.new(x, y)
        elsif tile == 13
          $objects["boxes"] << Box.new(x, y)
        elsif tile != 1
          tileset.set_tile(tile - 1, [{x: x*SIZE, y: y*SIZE}])
        end
      end
    end
  end

end

def draw_all_maps(id, tileset)
  draw_map_type(id, tileset, @current_map["floor_map"])
  draw_map_type(id, tileset, @current_map["wall_map"])
  draw_map_type(id, tileset, @current_map["object_map"])
end

def clear_map_and_objects()
    @current_map.clear
    $objects["buttons"].each do |button|
      button.sprite.remove
      # button.remove
    end
    $objects["boxes"].each do |box|
      box.sprite.remove
      # button.remove
    end
    $objects = {
      "buttons" => [],
      "boxes" => []
    }
  end


def change_map(player_x, player_y, load_x, load_y, next_map, button)
  @loading_zone.x = load_x*SIZE
  @loading_zone.y = load_y*SIZE

  $objects["boxes"].each do |box|
    $walls[box.y_pos][box.x_pos] = 'B'
  end

  door_handler($objects["buttons"])
  
  if player_x == load_x && player_y == load_y && button.pushed
    clear_map_and_objects()
    @transition.add
    @current_map = map_type(Tmx.load(@map_filepath[next_map]))
    draw_all_maps(define_tiles()[0], define_tiles()[1])
    $walls = draw_map_type(define_tiles()[0], define_tiles()[1], @current_map["wall_map"])
    @frames = 0
    return true
  else
    @frames = -600
    @transition.remove
    return false
  end

end

def update(player, button)
  @current_time = (Time.now.to_f*1000).to_i
    
    $objects["buttons"].each do |button|
      
      if @room[0] == @current_room && change_map(player.x_pos, player.y_pos, 7, 0, @room[1], button)
        player.y_pos = $walls.length - 2
        @current_room = next_room(1) #change to room 2
        player.sprite.add
        # p "change1"
      # elsif @room[1] == @current_room && change_map(player.x_pos, player.y_pos, 7, 11, @room[0], button)
      #   player.y_pos = $walls.length - 11
      #   player.sprite.add
      #   @current_room = next_room(0) #change to room 1
      #   # p "change back"
      elsif @room[1] == @current_room && change_map(player.x_pos, player.y_pos, 15, 6, @room[2], button)
        player.x_pos = 1
        @current_room = next_room(2) #change to room 3
        player.sprite.add
        # p "change2"
      elsif @room[2] == @current_room && change_map(player.x_pos, player.y_pos, 0, 6, @room[1], button)
        player.x_pos = 14
        @current_room = next_room(1) #change to toom 2
        player.sprite.add
      end
    end
end



end