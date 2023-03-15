require_relative './utils'

LEFT = 450
TOP = 10
WIDTH = 150
HEIGHT = 200

class Visualizer
  def self.draw_network(network)
    layer_gap = WIDTH / network.layers.length 

    (0...network.layers.length).each do |i|
      x = LEFT + lerp(0, WIDTH - layer_gap, i.to_f / (network.layers.length - 1))
      Visualizer.draw_layer(network.layers[i], x, layer_gap)
    end
  end

  def self.draw_layer(layer, pos_x, gap)
    right = LEFT + WIDTH
    bottom = TOP + HEIGHT

    layer.inputs.length.times do |i|
      layer.outputs.length.times do |j|
        Line.new(
          x1: pos_x, y1: Visualizer.get_node_y(layer.inputs, i, TOP, bottom),
          x2: pos_x + gap, y2: Visualizer.get_node_y(layer.outputs, j, TOP, bottom),
          color: [0.5, 0.8, 0.5, layer.weights[i][j] + 1]
        )
      end
    end

    layer.inputs.length.times do |i|
      y = Visualizer.get_node_y(layer.inputs, i, TOP, bottom)
      Visualizer.draw_node(5, pos_x, y, [1, 1, 0.3, layer.inputs[i]])
    end

    layer.outputs.length.times do |i|
      y = Visualizer.get_node_y(layer.outputs, i, TOP, bottom)
      Visualizer.draw_node(5, pos_x + gap, y, [1, 1, 0.3, layer.outputs[i]])
    end
  end

  def self.draw_node(radius, x, y, color)
    Circle.new(
      x: x, y: y,
      radius: radius + 2,
      color: "navy"
    )
    Circle.new(
      x: x, y: y,
      radius: radius, color: color
    )
  end

  
  def self.get_node_y(nodes, index, min_y, max_y)
    lerp(min_y, max_y, index.to_f / (nodes.length - 1))
  end
end
