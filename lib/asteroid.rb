class Asteroid
  attr_reader :rect

  def initialize
    @x = rand($window_width)
    @y = [-30, $window_height + 30].sample
    @vx = rand(-0.5..0.5)
    @vy = @y > $window_height ? rand(-0.5..-0.2) : rand(0.2..0.5)
    @angle = 0
    @size = 80
    @image = "assets/meteor#{rand(1..4)}.png"
    @rect = { x: @x, y: @y, width: @size, height: @size }
  end

  def draw
    Image.new(@image, x: @x, y: @y, width: @size, height: @size, rotate: @angle)
  end

  def update
    @x += @vx
    @y += @vy
    @angle += 0.5
    if @x.negative? || @x > $window_width
      @x = rand($window_width)
      @y = [-@size, $window_height + @size].sample
      @vx = rand(-0.5..0.5)
      @vy = @y > $window_height ? rand(-0.5..-0.2) : rand(0.2..0.5)
    end

    @angle = 0 if @angle > 359
    @rect[:x] = @x
    @rect[:y] = @y
  end
end
