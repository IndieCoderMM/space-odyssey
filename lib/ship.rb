require_relative './utils'
require_relative "./sensor"
require_relative "./network"

IMG_PATH = 'assets/ship_green.png'.freeze

class Ship
  attr_accessor :controls
  attr_reader :x, :y, :width, :height

  MAX_SPEED = 3
  ACCELERATION = 0.2
  FRICTION = 0.1

  def initialize(x, y, width, height)
    @x = x
    @y = y
    @width = width
    @height = height
    @angle = 0
    @speed = 5
    @img = nil

    @controls = {forward: false, left: false, right: false}
    @rect = { x: @x, y: @y, width: @width, height: @height }
    @sensor = Sensor.new(self, ray_count: 4)
    @brain = NeuralNetwork.new([@sensor.ray_count, 4, 3])
  end

  def draw
    @sensor.draw
    @img = Image.new(IMG_PATH, x: @x, y: @y, width: @width, height: @height, rotate: @angle)
    # Circle.new(x: @x + @width /2 , y: @y + @height /2, color: 'blue', radius: 10)
  end

  def angle_radians
    @angle * Math::PI / 180
  end

  def move 
    @speed += ACCELERATION if @controls[:forward]
    @speed -= FRICTION
    
    @angle += 1 if @controls[:right]
    @angle -= 1 if @controls[:left]

    @speed = [0, @speed, MAX_SPEED].sort[1]
    # @angle = [0, @angle, 360].sort[1]
    angle = angle_radians
    @x += @speed * Math.sin(angle)
    @y -= @speed * Math.cos(angle)

    @rect[:x] = @x
    @rect[:y] = @y
  end

  def update(borders, asteroids)
    @img.color = 'red' if is_collision?(asteroids)
    @sensor.update(borders, asteroids)

    offsets = @sensor.readings.map {|d| d.nil? ? 0 : 1 - d[:offset]}
    outputs = NeuralNetwork.feed_forward(offsets, @brain)
    # puts outputs.to_s
    # @controls[:forward] = outputs[0]
    # @controls[:left] = outputs[1]
    # @controls[:right] = outputs[2]

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
