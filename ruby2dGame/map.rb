require 'ruby2d'
require 'tmx'

# myfilepath = "map_folder//room_1.tmx"
myfilepath = "map_folder//room_2.tmx"

def map_type(map)
  p "hello"
  floor_map = nil
  wall_map = nil
  map.layers.each_with_index do |layer, index|
    if layer.name == "Floor layer"
      p "floor"
      floor_map = integrate_map(layer.data, layer.width)
    elsif layer.name == "Wall layer"
      p "wall"
      wall_map = integrate_map(layer.data, layer.width)
    end
  end
  return {"floor_map" => floor_map, "wall_map" => wall_map}
end

def integrate_map(layer_data, width)
    layer_map = []
    i = 0
    # p layer_data.length
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

@map = map_type(Tmx.load(myfilepath))

def define_tiles()
  tileset = Tileset.new(
    'img/map_v1.png',
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
  # tile_map = @map["wall_map"].each_with_index do |row, y|
  map_type.each_with_index do |row, y|
    row.each_with_index do |tile, x|
      if id.include?(tile)
        tileset.set_tile(tile - 1, [{x: x*SIZE, y: y*SIZE}])
      end
    end
  end

end

# puts "id#{define_tiles()}"
def draw_all_maps(id, tileset)
  draw_map_type(id, tileset, @map["floor_map"])
  draw_map_type(id, tileset, @map["wall_map"])
end

$walls = draw_map_type(define_tiles()[0], define_tiles()[1], @map["wall_map"])



draw_all_maps(define_tiles()[0], define_tiles()[1])