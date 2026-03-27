class Player
  #Player settings

  attr_accessor :hitbox, :move_x, :move_y, :x_pos, :y_pos

  def initialize(x, y)
    # @hitbox = Square.new(x: SIZE*4, y: SIZE*3, size: SIZE, color: 'blue', z: 500)
    @hitbox = Image.new("img/why.jpg", x: x*SIZE, y: y*SIZE, width: SIZE, height: SIZE)
    @move_x = 0
    @move_y = 0
    @x_pos = x
    @y_pos = y
    @pulling = false
  end

  def update()
    if Window.frames % 10 == 0
      new_x = @x_pos + @move_x
      new_y = @y_pos + @move_y
      #p $tile_map[new_y][new_x]
      #p new_x
      #p new_y
      #
      next_block = get_block(new_x, new_y)

      if next_block == nil
        move(new_x, new_y)
      elsif next_block.pushable == true && get_block(new_x + @move_x, new_y + @move_y) == nil
        move(new_x, new_y)
        next_block.push(@move_x, @move_y)
      end

    end
  end

  def pull_object(x,y)
    
  end

  def move(x, y)
    $tile_map[@y_pos][@x_pos] = 0
    if @pulling
      
    end

    @x_pos = x
    @y_pos = y
    @hitbox.x = @x_pos * SIZE
    @hitbox.y = @y_pos * SIZE
    #$tile_map[@y_pos][@x_pos] = 2
  end
end

