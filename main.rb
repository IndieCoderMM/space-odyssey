require 'ruby2d'
require_relative './lib/ship'
require_relative './lib/asteroid'

$window_width = 640
$window_height = 480

set title: 'Space Odyssey🚀', background: 'blue'
set width: $window_width, height: $window_height

ship = Ship.new(100, 50)
asteroids = Array.new(10) { Asteroid.new }
borders = [[{x: 10, y: 0}, {x: 10, y: $window_height}], [{x: $window_width - 10, y: 0}, {x: $window_width - 10, y: $window_height}]]

update do
  clear
  ship.draw
  ship.update(borders, asteroids)
  asteroids.each do |asteroid|
    asteroid.draw
    asteroid.update
  end
  Text.new("FPS: #{get(:fps).round(2)}", x: 10, y: 10)
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
