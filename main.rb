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
ships = Array.new(50) { Ship.new(Window.width / 2, Window.height / 2, 80, 50) }
asteroids = Array.new(10) { Asteroid.new }
visualizer = Visualizer.new(ships[0].brain)
gen = 1

fps_display = Text.new("FPS: 30", x: 10, y: 10)
gen_display = Text.new("GEN: 0", x: 10, y: 30)

update do
  damaged = 0
  ships.length.times do |i|
    if ships[i].damaged
      damaged += 1
      ships[i].remove 
    end
    ships[i].draw(sensor: i.zero?)
    ships[i].update(borders, asteroids)
  end
  asteroids.each do |asteroid|
    asteroid.update
  end
  visualizer.draw
  if damaged == ships.length 
    gen += 1
    ships.each {|ship| ship.respawn(Window.width / 2, Window.height / 2)}
    visualizer.init_network(ships[0].brain)
    asteroids.each do |asteroid|
      asteroid.respawn
    end
  end
  fps_display.text = "FPX:  #{get(:fps).round(2)}"
  gen_display.text = "GEN: #{gen}"
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
