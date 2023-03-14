require_relative "./utils"

class Sensor
  attr_reader :ray_count, :readings

  def initialize(ship, ray_count: 10, ray_length: 200, ray_spread: Math::PI / 2)
    @ship = ship 
    @ray_count = ray_count
    @ray_length = ray_length
    @ray_spread = ray_spread
    @rays = []
    @readings = []
  end

  def update(borders, asteroids)
    cast_rays
    @readings = []
    @rays.length.times do |i|
      @readings.push(get_reading(@rays[i], borders, asteroids))
    end
  end

  # @return [Array of lines]
  # Line = [{x: 0, y: 0}, {x: 1, y: 1}]
  def cast_rays
    @rays = []
    ship_dir = @ship.angle * Math::PI / 180
    @ray_count.times do |i|
      ray_angle = lerp(@ray_spread / 2, -@ray_spread/2, i.to_f/(@ray_count - 1)) - ship_dir
      start_pt = {x: @ship.x + @ship.width/2, y: @ship.y + @ship.height/2}
      end_pt = {
        x: @ship.x + @ship.width/2 - Math.sin(ray_angle) * @ray_length,
        y: @ship.y  + @ship.height/2 - Math.cos(ray_angle) * @ray_length
        }
      @rays.push([start_pt, end_pt])
    end
  end

  # Finds the closest intersection
  # @param ray [Array of 2 points] -> [{x1, y1}, {x2, y2}]
  # @param borders [Array of 2 lines]
  # @param asteroids [Array of asteroids]
  # @return intersect point with min offset -> {x, y, offset}
  def get_reading(ray, borders, asteroids)
    touches = []

    borders.length.times do |i|
      touch = get_intersect(ray[0], ray[1], borders[i][0], borders[i][1])
      touches.push(touch) if (touch) 
    end

    asteroids.each do |asteroid|
      collision_points = convert_rect_to_points(asteroid.rect)
      collision_points.length.times do |i|
        value = get_intersect(
          ray[0], ray[1],
          collision_points[i], collision_points[(i+1) % collision_points.length]
        )
        touches.push(value) if value
      end
    end

    return nil if touches.length === 0

    offsets = touches.map {|t| t[:offset]}
    min_offset = offsets.min()
    # puts "Min offset: #{min_offset}"
    return touches.select {|t| t[:offset] == min_offset}[0]
  end

  def draw 
    return if  @rays.length === 0
    @ray_count.times do |i|
      end_point = @readings[i] ? @readings[i] : @rays[i][1]
      Line.new(
        x1: @rays[i][0][:x], y1: @rays[i][0][:y],
        x2: end_point[:x], y2: end_point[:y],
        color: "yellow"
      )
      Line.new(
        x1: @rays[i][1][:x], y1: @rays[i][1][:y],
        x2: end_point[:x], y2: end_point[:y],
        color: "red"
      )
    end
  end
end

    