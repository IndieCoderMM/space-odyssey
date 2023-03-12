require 'ruby2d'
require_relative './lib/ship'
require_relative './lib/asteroid'

$window_width = 640
$window_height = 480

set title: 'Space Odyssey🚀', background: 'navy'
set width: $window_width, height: $window_height

ship = Ship.new(100, 50)
asteroids = Array.new(5) { Asteroid.new }

update do
  clear
  ship.update
  ship.draw
  asteroids.each do |asteroid|
    asteroid.draw
    asteroid.update
  end
  ship.img.color = 'red' if ship.is_collision?(asteroids)
end

on :key_held do |event|
  case event.key
  when 'right'
    ship.angle += 3
  when 'left'
    ship.angle -= 3
  when 'up'
    ship.moving = true
  end
end

on :key_up do |event|
  case event.key
  when 'up'
    ship.moving = false
  when 'down'
    ship.jump
  end
end

show
