require_relative './utils'
require_relative './sensor'
require_relative './network'

IMG_PATH = 'assets/ship'.freeze

class Ship < Image
  attr_accessor :controls
  attr_reader :x, :y, :width, :height, :brain, :success, :damaged, :rect, :sensor, :fitness

  MAX_SPEED = 5
  ACCELERATION = 0.2
  FRICTION = 0.05
  ROTATION = 3

  def initialize(width: 80, height: 60, target_x: 0, target_y: 0)
    @speed = 0
    @damaged = false
    @success = false
    @fitness = 0
    @controls = { forward: false, left: false, right: false, brake: false }
    @rect = { x: 0, y: 0, width: width, height: height }
    @sensor = Sensor.new(self, ray_count: 10, ray_spread: Math::PI * 2)
    @brain = NeuralNetwork.new([@sensor.ray_count, 5, 4])
    @target = {x: target_x, y: target_y}
    img_path = IMG_PATH + rand(1..5).to_s + '.png'
    super(img_path, x: 0, y: 0, width: width, height: height)
    # @score_display = Text.new(0, x: self.x, y: self.y)
    self.x = WIN_WIDTH / 2 - self.width / 2
    self.y = WIN_HEIGHT - self.height * 2
    self.z = 10
  end

  def draw
    return if @damaged
    self.color = 'red' if @damaged
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
    @speed -= ACCELERATION if @controls[:brake]
    @speed -= FRICTION

    self.rotate += ROTATION if @controls[:right]
    self.rotate -= ROTATION if @controls[:left]

    @speed = [0, @speed, MAX_SPEED].sort[1]
    angle = angle_radians
    self.x += @speed * Math.sin(angle)
    self.y -= @speed * Math.cos(angle)
  end

  def clone_gene(gene)
    @brain.layers = gene.map(&:clone)
  end

  def new_gene
    @brain.generate_layers
  end

  def evaluate_fitness
    distance = dist(self.x, self.y, @target[:x], @target[:y])
    @fitness = 1 / distance
    @fitness *= 100 if @success
  end

  def update(borders, asteroids, target)
    return if @damaged || @success
    @rect[:x] = self.x
    @rect[:y] = self.y

    move
    @sensor.update(borders, asteroids, target)
    
    offsets = @sensor.readings.map { |d| d.nil? ? 0 : 1 - d[:offset] }
    outputs = NeuralNetwork.feed_forward(offsets, @brain)
    @controls[:forward] = outputs[0] == 1
    @controls[:left] = outputs[1] == 1
    @controls[:right] = outputs[2] == 1
    # @controls[:brake] = outputs[3] == 1
    
    @damaged = collides?(asteroids) || out_of_bound?
    @success = (target.x - self.x).abs < self.width && (target.y - self.y).abs < self.height
  end

  def out_of_bound?
    self.x < -self.width || self.x > WIN_WIDTH || self.y < -self.height || self.y > WIN_HEIGHT
  end

  def locate_random
    self.x = rand(self.width..WIN_WIDTH - self.width)
    self.y = rand(self.height..WIN_HEIGHT - self.height)
  end

  def collides?(asteroids)
    asteroids.each do |asteroid|
      return true if rect_collide?(@rect, asteroid.rect)
    end
    false
  end

  def respawn
    add
    self.x = WIN_WIDTH / 2 - self.width / 2
    self.y = WIN_HEIGHT - self.height * 2
    @damaged = false
    @success = false
    @fitness = 0
    @sensor.init_drawings
  end

  def destroy 
    remove 
    @sensor.clear_drawings
  end
end
