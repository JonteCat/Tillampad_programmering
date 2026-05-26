class Player
  #Player settings

  attr_accessor :hitbox, :move_x, :move_y, :x_pos, :y_pos, :sprite, :pulling, :frames

  def initialize(x, y)
    @sprite = Sprite.new('img/map_v1.png', x: x*SIZE, y: y*SIZE, z: 10, width: 32, height: 32, clip_width: 16, clip_height: 16, time: 100, animations: {down: 0..0, up: 1..1, right: 2..2, left: 3..3})
    @move_x = 0
    @move_y = 0
    @x_pos = x
    @y_pos = y
    @pulling = false
    @frames = 0
  end

  # This function moves the player and takes a new x and y value
  #
  # @param argument1 [Integer] x value
  # @param argument2 [integer] y value
  # @return [nil] nothing
  #
  # @author Jonathan Wiklund
  def move(x, y)
      $walls[@y_pos][@x_pos] = 0
      @x_pos = x
      @y_pos = y

      $walls[@y_pos][@x_pos] = 'P'
  end

  # This function covers the pulling logic and moves a box backwards
  #
  # @param argument1 [Box] the box that is pulled
  # @param argument2 [Integer] the old x value
  # @param argument3 [Integer] the new x value
  # @return [nil] nothing
  #
  # @author Jonathan Wiklund
  def pulling(box, old_x, old_y)
    @frames = -27
    move(old_x, old_y)
    box.move(old_x-@move_x, old_y-@move_y)
  
    
  end

  # def update(box, button)
  def update()
    # print "#{self.x_pos}, #{self.y_pos}"
      @sprite.x = @x_pos * SIZE
      @sprite.y = @y_pos * SIZE
    @frames += 1
    
    if (@move_x != 0 or @move_y != 0) && @frames > 10
      @frames = 0
      new_x = @x_pos + @move_x
      new_y = @y_pos + @move_y
      player_next_tile_empty = $walls[new_y][new_x] == 0

      box_next_tile_empty = false
      $objects["buttons"].each do |button|
        button.pushed?(new_x, new_y)
        $objects["boxes"].each do |box|
          button.pushed?(box.x_pos, box.y_pos)
          if $walls[box.y_pos - @move_y][box.x_pos] == 'P' || $walls[box.y_pos][box.x_pos - @move_x] == 'P' #Checks if player is behind box
            box_next_tile_empty = $walls[box.y_pos+@move_y][box.x_pos+@move_x] == 0 #Checks the nex tile of only the box being pushed
          end
          if button.pushed == true
            break
          end
        end
      end
      
      $objects["boxes"].each do |box|
        if player_next_tile_empty && ($walls[box.y_pos + @move_y][box.x_pos] == 'P' || $walls[box.y_pos][box.x_pos + @move_x] == 'P') && @pulling #&& @frames > 30
          p "hi player"
          pulling(box, new_x, new_y)
        end
      end

        if player_next_tile_empty && @pulling == false
            move(new_x, new_y)

        elsif $walls[new_y][new_x] == 'B' && @pulling == false
          p box_next_tile_empty
          if box_next_tile_empty
            $objects["boxes"].each do |box|
              # p $walls[box.y_pos - @move_y][box.x_pos] == 'P' || $walls[box.y_pos][box.x_pos - @move_x] == 'P'
              if $walls[box.y_pos - @move_y][box.x_pos] == 'P' || $walls[box.y_pos][box.x_pos - @move_x] == 'P'
                @frames = -10
                box.move(new_x+@move_x, new_y+@move_y)
                move(new_x, new_y)
              end
            end
          end    
        end
    end
  end
end

