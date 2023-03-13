require_relative './utils'
require_relative "./sensor"

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
    @width = 80
    @height = 80
    @moving = false
    @rect = { x: @x, y: @y, width: @width, height: @height }
    @img = nil
    @sensor = Sensor.new(self, ray_count: 20)
  end

  def draw
    @sensor.draw
    @img = Image.new(IMG_PATH, x: @x, y: @y, rotate: @angle)
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
    return unless @moving
    move 
  end

  def jump
    rand_x = rand($window_width)
    rand_y = rand($window_height)
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
