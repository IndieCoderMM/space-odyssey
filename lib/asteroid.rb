# WIN_WIDTH = 1200
# WIN_HEIGHT = 800

class Asteroid < Image
  attr_reader :rect
  SIZE = 100

  def initialize
    img_path = "assets/meteor#{rand(1..4)}.png"
    x = 0
    y = 0
    super(img_path, x: x, y: y, width: SIZE, height: SIZE)
    @rect = { x: x, y: y, width: SIZE, height: SIZE }
    @color = Color.new('random')
    @vx = 0
    @vy = 0
    respawn
  end

  def respawn
    self.x = rand(WIN_WIDTH)
    self.y = [-SIZE, WIN_HEIGHT + SIZE].sample
    @vx = rand(-5..5)
    @vy = rand(1..3)
    @vy *= -1 if self.y > WIN_HEIGHT
    @rect[:x] = self.x
    @rect[:y] = self.y
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
