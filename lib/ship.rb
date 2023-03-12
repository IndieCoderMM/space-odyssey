require_relative './utils'

IMG_PATH = 'assets/ship_green.png'.freeze

class Ship
  attr_accessor :v_x, :v_y, :angle, :moving, :img

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
  end

  def draw
    @img = Image.new(IMG_PATH, x: @x, y: @y, rotate: @angle)
  end

  def update
    return unless moving

    direction = @angle * Math::PI / 180

    @x += @speed * Math.sin(direction)
    @y -= @speed * Math.cos(direction)

    @rect[:x] = @x
    @rect[:y] = @y
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
