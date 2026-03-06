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
      new_x = @move_x * SIZE
      new_y = @move_y * SIZE
=begin 
      tile_map[new_y/SIZE]

      $tile_map.each_with_index do |row, y|
        row.each_with_index do |tile, x|
          
            
          end
        end
                
      end
=end
      @hitbox.x += new_x
      @hitbox.y += new_y
    end
  end
end