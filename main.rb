require 'ruby2d'
require_relative './lib/ship'
require_relative './lib/asteroid'
require_relative './lib/visualizer'

$window_width = 640
$window_height = 480

set title: 'Space Odyssey🚀', background: 'blue'
set width: $window_width, height: $window_height

borders = [
  [{ x: 10, y: 0 }, { x: 10, y: $window_height }],
  [{ x: $window_width - 10, y: 0 }, { x: $window_width - 10, y: $window_height }],
  [{ x: 10, y: 10 }, { x: $window_width - 10, y: 10 }],
  [{ x: 10, y: $window_height - 10 }, { x: $window_width - 10, y: $window_height - 10 }]
]
ships = Array.new(5) { Ship.new($window_width / 2, $window_height / 2, 80, 50) }
best_brain = ships[0].brain.layers
asteroids = Array.new(5) { Asteroid.new }
gen = 1

def next_generation(best_brain)
  ships = Array.new(5) { Ship.new($window_width / 2, $window_height / 2, 80, 50) }
  ships[0].brain.layers = best_brain
  ships
end

update do
  clear
  ships.length.times do |i|
    ships[i].draw(sensor: i.zero?)
    ships[i].update(borders, asteroids)
  end
  asteroids.each do |asteroid|
    asteroid.draw
    asteroid.update
  end
  Text.new("FPS: #{get(:fps).round(2)}", x: 10, y: 10)
  Text.new("GEN: #{gen}", x: 10, y: 30)
  # Visualizer.drawLayer(ship.brain.layers[0])
  Visualizer.draw_network(ships[0].brain)
  ships = ships.reject(&:damaged)
  if ships.empty?
    gen += 1
    ships = next_generation(best_brain)
    asteroids = Array.new(5) { Asteroid.new }

  end
  best_brain = ships[0].brain.layers
end

# on :key_held do |event|
#   case event.key
#   when 'right'
#     ship.controls[:right] = true
#   when 'left'
#     ship.controls[:left] = true
#   when 'up'
#     ship.controls[:forward] = true
#   end
# end

on :key_up do |event|
  case event.key
  # when 'right'
  #   ship.controls[:right] = false
  # when 'left'
  #   ship.controls[:left] = false
  # when 'up'
  #   ship.controls[:forward] = false
  when 'down'
    ships.each(&:jump)
  when 'r'
    ships = Array.new(5) { Ship.new($window_width / 2, $window_height / 2, 80, 50) }
  end
end

show
