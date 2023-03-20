require 'ruby2d'
require_relative './lib/population'
require_relative './lib/asteroid'
require_relative './lib/visualizer'

WIN_WIDTH = 1200
WIN_HEIGHT = 800

set title: 'Space Odyssey🚀', background: 'blue'
set width: 1200, height: 800
set fps_cap: 30

LIFE_SPAN = 300

borders = [
  [{ x: 10, y: 0 }, { x: 10, y: Window.height }],
  [{ x: Window.width - 10, y: 0 }, { x: Window.width - 10, y: Window.height }],
  [{ x: 10, y: 10 }, { x: Window.width - 10, y: 10 }],
  [{ x: 10, y: Window.height - 10 }, { x: Window.width - 10, y: Window.height - 10 }]
]
target = Image.new('assets/star_gold.png', x: Window.width/2, y: 50, width: 60, height: 60)

population = Population.new(30, target.x, target.y)
asteroids = Array.new(8) { Asteroid.new }
visualizer = Visualizer.new(population.ship_model.brain)

fps_display = Text.new("FPS: 30", x: 10, y: 10)
gen_display = Text.new("GEN: 0", x: 10, y: 30)
fitness_display = Text.new("FITNESS: 0", x: 10, y: 50)
time_display = Text.new("Time: 0", x: 10, y: 70)
rating_display = Text.new("Rating: 0", x: 10, y: 90)

time = 0

update do
  time += 1
  if time == LIFE_SPAN
    population.next_generation
    time = 0
    asteroids.each {|asteroid| asteroid.respawn}
  end
  population.update(borders, asteroids, target)

  model = population.ship_model
  visualizer.draw(model.brain) if model 
  model.sensor.draw if model

  asteroids.each {|asteroid| asteroid.update}
  
  fps_display.text = "FPS:  #{get(:fps).round(2)}"
  gen_display.text = "GEN: #{population.gen_no}"
  fitness_display.text = "FITNESS: #{population.max_fit.round(3)}"
  time_display.text = "TIME: #{time}"
  rating_display.text = "Rating: #{population.success_rate}"
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
