class Player
  #Player settings

  attr_accessor :hitbox, :move_x, :move_y, :x_pos, :y_pos

  def initialize()
    @hitbox = Square.new(x: SIZE*4, y: SIZE*3, size: SIZE, color: 'blue', z: 500)
    @move_x = 0
    @move_y = 0
    @move = false

    @x_pos = 0
    @y_pos = 0
  end


  def update()
    if Window.frames % 10 == 0
      # new_x = @move_x * SIZE
      # new_y = @move_y * SIZE
      @move = false
      
      new_x = @x_pos + @move_x
      new_y = @y_pos + @move_y

      if $tile_map[new_y][new_x] != 1
        @move = true
      end
        
        if @hitbox.x/SIZE > 0 && @hitbox.x/SIZE < 15 #&& (@hitbox.y).contains? 0, 11
          
        end
        if @move
          #p "i should move"
          p new_x
          @hitbox.x = @x_pos * SIZE
          #move = false
        end
        #@hitbox.x += new_x
        @hitbox.y = @y_pos * SIZE
    end
  end
end