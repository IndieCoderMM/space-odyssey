require 'ruby2d'
require_relative './lib/ship'
require_relative './lib/asteroid'
require_relative './lib/visualizer'

$window_width = 640
$window_height = 480

set title: 'Space Odyssey🚀', background: 'blue'
set width: $window_width, height: $window_height

ship = Ship.new(100, 50, 100, 80)
asteroids = Array.new(10) { Asteroid.new }
borders = [
  [{ x: 10, y: 0 }, { x: 10, y: $window_height }],
  [{ x: $window_width - 10, y: 0 }, { x: $window_width - 10, y: $window_height }],
  [{ x: 10, y: 10 }, { x: $window_width - 10, y: 10 }],
  [{ x: 10, y: $window_height - 10 }, { x: $window_width - 10, y: $window_height - 10 }]
]

update do
  clear
  ship.draw
  ship.update(borders, asteroids)
  asteroids.each do |asteroid|
    asteroid.draw
    asteroid.update
  end
  Text.new("FPS: #{get(:fps).round(2)}", x: 10, y: 10)
  # Visualizer.drawLayer(ship.brain.layers[0])
  Visualizer.draw_network(ship.brain)
end

on :key_held do |event|
  case event.key
  when 'right'
    ship.controls[:right] = true
  when 'left'
    ship.controls[:left] = true
  when 'up'
    ship.controls[:forward] = true
  end
end

on :key_up do |event|
  case event.key
  when 'right'
    ship.controls[:right] = false
  when 'left'
    ship.controls[:left] = false
  when 'up'
    ship.controls[:forward] = false
  when 'down'
    ship.jump
  end
end

show
