require 'ruby2d'
require_relative './lib/population'
require_relative './lib/asteroid'
require_relative './lib/visualizer'

WIN_WIDTH = 800
WIN_HEIGHT = 640

set title: 'Space Odyssey🚀', background: 'blue'
set width: WIN_WIDTH, height: WIN_HEIGHT
set fps_cap: 60

LIFE_SPAN = 500

borders = [
  [{ x: 10, y: 0 }, { x: 10, y: Window.height }],
  [{ x: Window.width - 10, y: 0 }, { x: Window.width - 10, y: Window.height }],
  [{ x: 10, y: 10 }, { x: Window.width - 10, y: 10 }],
  [{ x: 10, y: Window.height - 10 }, { x: Window.width - 10, y: Window.height - 10 }]
]

population = Population.new(20)
asteroids = Array.new(5) { Asteroid.new }
visualizer = Visualizer.new(population.ship_model.brain)

fps_display = Text.new("FPS: 30", x: 10, y: 30)
gen_display = Text.new("GEN: 0", x: 10, y: 10)
fitness_display = Text.new("FITNESS: 0", x: 10, y: 50)
time_display = Text.new("Time: 0", x: 10, y: 70)
rating_display = Text.new("Rating: 0", x: 10, y: 90)

time = 0

update do
  time += 1
  if population.all_destroyed? || time >= LIFE_SPAN
    time = 0
    population.next_generation
    asteroids.each {|asteroid| asteroid.respawn}
  end
  population.update(borders, asteroids)

  model = population.ship_model
  visualizer.draw(model.brain) if model 
  model.sensor.draw if model

  asteroids.each {|asteroid| asteroid.update}
  
  fps_display.text = "FPS:  #{get(:fps).round(0)}"
  gen_display.text = "GEN: #{population.gen_no}"
  fitness_display.text = "FITNESS: #{population.max_fit.round(3)}"
  time_display.text = "TIME: #{time}"
  rating_display.text = "Rating: #{population.success_rate.round(2)}"
end

on :key_up do |event|
  case event.key 
  when 'up'
    asteroids << Asteroid.new 
  when 'down'
    asteroid = asteroids.pop 
    asteroid.remove
  when 'left'
    population.next_generation
  end
end

show
