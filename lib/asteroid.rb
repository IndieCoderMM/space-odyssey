class Asteroid
  attr_reader :rect

  def initialize
    @x = 0
    @y = 0
    @vx = 0
    @vy = 0
    @angle = 0
    @size = 60
    @image = "assets/meteor#{rand(1..4)}.png"
    @rect = { x: @x, y: @y, width: @size, height: @size }
    respawn
  end

  def draw
    Image.new(@image, x: @x, y: @y, width: @size, height: @size, rotate: @angle)
  end

  def respawn
    @x = rand($window_width)
    @y = [-@size, $window_height + @size].sample
    @vx = rand(-1..1)
    @vy = @y > $window_height ? rand(-1..-0.5) : rand(0.5..1)
  end

  def update
    @x += @vx
    @y += @vy
    @angle += 0.5
    respawn if @x < -@size || @x > $window_width + @size || @y < -@size * 2 || @y > $window_height + (@size * 2)

    @angle = 0 if @angle > 359
    @rect[:x] = @x
    @rect[:y] = @y
  end
end
