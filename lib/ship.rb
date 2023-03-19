require_relative './utils'
require_relative './sensor'
require_relative './network'

IMG_PATH = 'assets/ship_green.png'.freeze

class Ship < Image
  attr_accessor :controls
  attr_reader :x, :y, :width, :height, :brain, :damaged, :rect

  MAX_SPEED = 5
  ACCELERATION = 0.2
  FRICTION = 0.05

  def initialize(x, y, width, height, img_path: IMG_PATH)
    @speed = 0
    self.rotate = 0
    
    @damaged = false
    @score = 0
    @controls = { forward: false, left: false, right: false }
    @rect = { x: x, y: y, width: width, height: height }
    @sensor = Sensor.new(self, ray_count: 10, ray_spread: Math::PI * 2)
    @brain = NeuralNetwork.new([@sensor.ray_count, 5, 3])
    super(img_path, x: x, y: y, width: width, height: height)
    @score_display = Text.new(0, x: self.x, y: self.y)
  end

  def draw(sensor: false)
    return if @damaged
    @sensor.draw if sensor
    self.color = 'red' if @damaged
    @score_display.text = @score.round(2)
    # Circle.new(x: @x + self.width /2 , y: @y + self.height /2, color: 'orange', radius: 20)
  end

  def angle_radians
    self.rotate * Math::PI / 180
  end

  def gene
    @brain.layers 
  end

  def move
    @speed += ACCELERATION if @controls[:forward]
    @speed -= FRICTION

    self.rotate += 1 if @controls[:right]
    self.rotate -= 1 if @controls[:left]

    @speed = [0, @speed, MAX_SPEED].sort[1]
    angle = angle_radians
    self.x += @speed * Math.sin(angle)
    self.y -= @speed * Math.cos(angle)
    
  end

  def update(borders, asteroids)
    return if @damaged
    @rect[:x] = self.x
    @rect[:y] = self.y
    @score_display.x = self.x 
    @score_display.y = self.y
    @score += @speed
    @damaged = collides?(asteroids) || out_of_bound?
    move

    @sensor.update(borders, asteroids)

    offsets = @sensor.readings.map { |d| d.nil? ? 0 : 1 - d[:offset] }
    outputs = NeuralNetwork.feed_forward(offsets, @brain)
    @controls[:forward] = outputs[0] == 1
    @controls[:left] = outputs[1] == 1
    @controls[:right] = outputs[2] == 1

  end

  def out_of_bound?
    self.x < -self.width || self.x > WIN_WIDTH + self.width || self.y < -self.height || self.y > WIN_HEIGHT + self.height
  end

  def jump
    self.x = rand(self.width..WIN_WIDTH - self.width)
    self.y = rand(self.height..WIN_HEIGHT - self.height)
  end

  def collides?(asteroids)
    asteroids.each do |asteroid|
      return true if rect_collide?(@rect, asteroid.rect)
    end
    false
  end

  def respawn(x, y)
    add
    self.x = x
    self.y = y
    @score_display.add 
    @damaged = false
    @sensor.init_drawings
  end

  def remove 
    super
    @score_display.remove 
    @sensor.clear_drawings
  end
end
