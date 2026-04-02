require 'tmx'

myfilepath = "room_1.tmx"

map = Tmx.load(myfilepath)


#p map.methods
#p map.layers
p map.properties=