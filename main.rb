require 'ruby2d'

WIDTH = 640
HEIGHT = 480

set title: "Space Odyssey🚀", background: "navy", width: WIDTH, height: HEIGHT

class Ship 
    attr_accessor :v_x, :v_y, :angle, :moving

    def initialize(x, y)
        @x = x
        @y = y
        # @size = 100
				@angle = 0
				@speed = 5
        @v_x = 0
        @v_y = 0
				@moving = false
    end 

    def draw
			Image.new(
				'assets/ship_green.png', x: @x, y: @y, rotate: @angle
			)
    end

    def move 
			return if !moving
			direction = @angle * Math::PI / 180

			@x += @speed * Math.sin(direction)
			@y -= @speed * Math.cos(direction)
		end

		def jump 
			rand_x = rand(WIDTH)
			rand_y = rand(HEIGHT)
			@x = rand_x
			@y = rand_y
		end

end

class Aestroid 
	def initialize
		@x = rand(WIDTH)
		@y = [-10, HEIGHT + 10][rand(1)]
		@vx = rand(-0.5..0.5)
		@vy = @y > HEIGHT ? rand(-0.5..-0.2) : rand(0.2..0.5)
		@angle = 0
		@size = 80
		@image = "assets/meteor#{rand(1..4)}.png"
	end 

	def draw 
		Image.new(@image, x: @x, y: @y, width: @size, height: @size, rotate: @angle)
	end

	def update 
		@x += @vx 
		@y += @vy 
		@angle += 0.5
		if @x < 0 || @x > WIDTH
			@x = rand(WIDTH)
			@y = [-10, HEIGHT + 10][rand(1)]
			@vx = rand(-0.5..0.5)
			@vy = @y > HEIGHT ? rand(-0.5..-0.2) : rand(0.2..0.5)
		end

		@angle = 0 if @angle > 359
	end
end

ship = Ship.new(100, 50)

aestroids = Array.new(5) {Aestroid.new}
puts aestroids
update do 
    clear
    ship.move 
    ship.draw 
		aestroids.each do |aestroid|
			aestroid.draw 
			aestroid.update
		end
end

on :key_held do |event|
	case event.key 
	when "right"
		ship.angle += 3
	when "left"
		ship.angle -= 3
	when "up" 
		ship.moving = true
	end
end

on :key_up do |event|
	case event.key 
	when "up"
		ship.moving = false
	when "down"
		ship.jump
	end
end

show