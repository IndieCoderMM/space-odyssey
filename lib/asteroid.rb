class Asteroid < Image
  attr_reader :rect

  SIZE = 100
  VX = 2
  VY = 1

  def initialize
    img_path = "assets/meteor#{rand(1..4)}.png"
    x = 0
    y = 0
    super(img_path, x: x, y: y, width: SIZE, height: SIZE)
    @rect = { x: x, y: y, width: SIZE, height: SIZE }
    @vx = 0
    @vy = 0
    respawn
  end

  def respawn
    self.x = rand(WIN_WIDTH)
    self.y = [-height, WIN_HEIGHT + height].sample
    @vx = rand(-VX..VX)
    @vy = VY
    @vy *= -1 if y > WIN_HEIGHT
    @rect[:x] = x
    @rect[:y] = y
  end

  def update
    self.x += @vx
    self.y += @vy
    self.rotate += 1
    respawn if self.x < -SIZE || self.x > WIN_WIDTH + SIZE || self.y < -SIZE || self.y > WIN_HEIGHT + SIZE
    @rect[:x] = self.x
    @rect[:y] = self.y
  end
end
