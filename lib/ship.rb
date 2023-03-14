require_relative './utils'
require_relative "./sensor"
require_relative "./network"

IMG_PATH = 'assets/ship_green.png'.freeze

class Ship
  attr_accessor :v_x, :v_y, :angle, :moving
  attr_reader :x, :y, :width, :height

  def initialize(x, y)
    @x = x
    @y = y
    @angle = 0
    @speed = 5
    @v_x = 0
    @v_y = 0
    @width = 100
    @height = 80
    @moving = false
    @rect = { x: @x, y: @y, width: @width, height: @height }
    @img = nil
    @sensor = Sensor.new(self, ray_count: 4)
    @brain = NeuralNetwork.new([@sensor.ray_count, 4, 4])
  end

  def draw
    @sensor.draw
    @img = Image.new(IMG_PATH, x: @x, y: @y, width: @width, height: @height, rotate: @angle)
    # Circle.new(x: @x + @width /2 , y: @y + @height /2, color: 'blue', radius: 10)
  end

  def move 
    direction = @angle * Math::PI / 180

    @x += @speed * Math.sin(direction)
    @y -= @speed * Math.cos(direction)

    @rect[:x] = @x
    @rect[:y] = @y
  end

  def update(borders, asteroids)
    @img.color = 'red' if is_collision?(asteroids)
    @sensor.update(borders, asteroids)

    offsets = @sensor.readings.map {|d| d.nil? ? 0 : 1 - d[:offset]}
    outputs = NeuralNetwork.feed_forward(offsets, @brain)
    puts outputs.to_s
    
    @moving = outputs[0] == 1

    return unless @moving
    move 
  end

  def jump
    rand_x = rand(@width..$window_width - @width)
    rand_y = rand(@height..$window_height - @height)
    @x = rand_x
    @y = rand_y
  end

  def is_collision?(asteroids)
    asteroids.each do |asteroid|
      return true if rect_collide?(@rect, asteroid.rect)
    end
    false
  end
end
