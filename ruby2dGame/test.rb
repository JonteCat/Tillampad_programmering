$tile_map.each_with_index do |row, y|
row.each_with_index do |tile, x|
  if tile == 2
    case (new_x/SIZE)
    when 1
      temp = x + 1
      row[x] = 0
      x = temp
      row[x] = 2
    when -1
      temp = x - 1
      row[x] = 0
      x = temp
      row[x] = 2
    end
    if x > 16
      x = 0
    end
    #x = 0
  end  
end

