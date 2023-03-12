require 'ruby2d'
require_relative "./lib/ship"
require_relative "./lib/aestroid"

$window_width = 640
$window_height = 480

set title: "Space Odyssey🚀", background: "navy"
set width: $window_width, height: $window_height

ship = Ship.new(100, 50)
aestroids = Array.new(5) {Aestroid.new}

update do 
    clear
    ship.update 
    ship.draw 
		aestroids.each do |aestroid|
			aestroid.draw 
			aestroid.update
		end
    if ship.is_collision?(aestroids)
      ship.img.color = "red"
    end
end

on :key_held do |event|
	case event.key 
	when "right"
		ship.angle += 3
	when "left"
		ship.angle -= 3
	when "up" 
		ship.moving = true
	end
end

on :key_up do |event|
	case event.key 
	when "up"
		ship.moving = false
	when "down"
		ship.jump
	end
end

show