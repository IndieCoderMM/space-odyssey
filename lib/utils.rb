def lerp(a, b, t)
  a + ((b - a) * t)
end

def dist(x1, y1, x2, y2)
  Math.sqrt(((x2 - x1)**2) + ((y2 - y1)**2))
end

# @params points [Hash] x, y coordinates of 2 lines
def get_intersect(a, b, c, d)
  t_top = ((d[:x] - c[:x]) * (a[:y] - c[:y])) - ((d[:y] - c[:y]) * (a[:x] - c[:x]))
  u_top = ((c[:y] - a[:y]) * (a[:x] - b[:x])) - ((c[:x] - a[:x]) * (a[:y] - b[:y]))
  bottom = ((d[:y] - c[:y]) * (b[:x] - a[:x])) - ((d[:x] - c[:x]) * (b[:y] - a[:y]))

  if bottom != 0
    t = t_top / bottom
    u = u_top / bottom
    return { x: lerp(a[:x], b[:x], t), y: lerp(a[:y], b[:y], t), offset: t } if t >= 0 && t <= 1 && u >= 0 && u <= 1
  end
  nil
end

# @param rect [Hash] :x, :y, :width, :height
# @return [Array] Array of 4 points [[{:x1,:y1},...,{:x4,:y4}]
def convert_rect_to_points(rect)
  p1 = { x: rect[:x], y: rect[:y] }
  p2 = { x: rect[:x] + rect[:width], y: rect[:y] }
  p3 = { x: rect[:x], y: rect[:y] + rect[:height] }
  p4 = { x: rect[:x] + rect[:width], y: rect[:y] + rect[:height] }
  [p1, p2, p3, p4]
end

# @param rect1 [Hash] :x, :y, :width, :height
# @param rect2 [Hash] :x, :y, :width, :height
# @return [Boolean]
def rect_collide?(rect1, rect2)
  points1 = convert_rect_to_points(rect1)
  points2 = convert_rect_to_points(rect2)
  poly_intersect?(points1, points2)
end

def poly_intersect?(points1, points2)
  points1.length.times do |i|
    points2.length.times do |j|
      intersect = get_intersect(points1[i], points1[(i + 1) % points1.length], points2[j],
                                points2[(j + 1) % points2.length])
      return true if intersect
    end
  end
  false
end
