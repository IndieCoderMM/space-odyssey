require_relative './utils'

class Visualizer
  TOP = 20
  WIDTH = 150
  HEIGHT = 200
  LEFT = 800 - WIDTH - 20

  def initialize(network)
    @line_drawings = []
    @node_drawings = []
    init_network(network)
  end

  def init_network(network)
    @network = network
    @line_drawings = clear_drawings(@line_drawings)
    @node_drawings = clear_drawings(@node_drawings)
  end

  def clear_drawings(drawings)
    drawings.each(&:remove)
    []
  end

  def draw(network)
    @line_drawings = clear_drawings(@line_drawings)
    @node_drawings = clear_drawings(@node_drawings)

    draw_network(network)
  end

  def draw_network(network)
    layer_gap = WIDTH / network.layers.length

    (0...network.layers.length).each do |i|
      x = LEFT + lerp(0, WIDTH - layer_gap, i.to_f / (network.layers.length - 1))
      draw_layer(network.layers[i], x, layer_gap)
    end
  end

  def draw_layer(layer, pos_x, gap)
    bottom = TOP + HEIGHT

    layer.inputs.length.times do |i|
      layer.outputs.length.times do |j|
        @line_drawings << Line.new(
          x1: pos_x, y1: get_node_y(layer.inputs, i, TOP, bottom),
          x2: pos_x + gap, y2: get_node_y(layer.outputs, j, TOP, bottom),
          color: [0.5, 0.8, 0.5, (layer.weights[i][j] + 1) || 0]
        )
      end
    end

    layer.inputs.length.times do |i|
      y = get_node_y(layer.inputs, i, TOP, bottom)
      color = [1, 1, 0.3, layer&.inputs&.[](i) || 0]
      draw_node(5, pos_x, y, color)
    end

    layer.outputs.length.times do |i|
      y = get_node_y(layer.outputs, i, TOP, bottom)
      color = [1, 1, 0.3, layer&.outputs&.[](i) || 0]
      draw_node(5, pos_x + gap, y, color)
    end
  end

  def draw_node(radius, x, y, color)
    @node_drawings << Circle.new(
      x: x, y: y,
      radius: radius + 2,
      color: 'navy'
    )
    @node_drawings << Circle.new(
      x: x, y: y,
      radius: radius, color: color
    )
  end

  def get_node_y(nodes, index, min_y, max_y)
    lerp(min_y, max_y, index.to_f / (nodes.length - 1))
  end
end
