require 'ruby2d'
require_relative './lib/ship'
require_relative './lib/asteroid'
require_relative './lib/visualizer'

WIN_WIDTH = 1200
WIN_HEIGHT = 800

set title: 'Space Odyssey🚀', background: 'blue'
set width: 1200, height: 800
set fps_cap: 30

borders = [
  [{ x: 10, y: 0 }, { x: 10, y: Window.height }],
  [{ x: Window.width - 10, y: 0 }, { x: Window.width - 10, y: Window.height }],
  [{ x: 10, y: 10 }, { x: Window.width - 10, y: 10 }],
  [{ x: 10, y: Window.height - 10 }, { x: Window.width - 10, y: Window.height - 10 }]
]
ships = Array.new(5) { Ship.new(Window.width / 2, Window.height / 2, 80, 50) }
asteroids = Array.new(5) { Asteroid.new }
visualizer = Visualizer.new(ships[0].brain)
gen = 1

fps_display = Text.new("FPS: #{get(:fps).round(2)}", x: 10, y: 10)
gen_display = Text.new("GEN: #{gen}", x: 10, y: 30)

update do
  ships.length.times do |i|
    ships[i].draw(sensor: i.zero?)
    ships[i].update(borders, asteroids)
    ships[i].remove if ships[i].damaged
  end
  asteroids.each do |asteroid|
    asteroid.draw
    asteroid.update
  end
  visualizer.draw
  ships = ships.reject(&:damaged)
  if ships.length.zero? 
    ships = Array.new(5) { Ship.new(Window.width / 2, Window.height / 2, 80, 50) }
    visualizer.network = ships[0].brain 
  end
end

on :key_up do |event|
  case event.key
  when 'down'
    ships.each(&:jump)
  when 'r'
    ships = Array.new(5) { Ship.new(Window.width / 2, Window.height / 2, 80, 50) }
  end
end

show
