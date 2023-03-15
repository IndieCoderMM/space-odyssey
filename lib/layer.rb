class Layer
  attr_accessor :inputs, :outputs, :weights, :biases

  def initialize(input_count, output_count)
    @inputs = Array.new(input_count)
    @outputs = Array.new(output_count)
    @biases = Array.new(output_count)
    @weights = []
    input_count.times do |_i|
      @weights.push(Array.new(output_count))
    end
    Layer.randomize(self)
  end

  def self.randomize(layer)
    layer.inputs.length.times do |i|
      layer.outputs.length.times do |j|
        layer.weights[i][j] = (rand * 2) - 1
      end
    end

    layer.biases.length.times do |i|
      layer.biases[i] = (rand * 2) - 1
    end
  end

  def self.feed_forward(inputs, layer)
    layer.inputs.length.times do |i|
      layer.inputs[i] = inputs[i]
    end

    layer.outputs.length.times do |i|
      sum = 0
      layer.inputs.length.times do |j|
        sum += layer.inputs[j] * layer.weights[j][i]
      end

      layer.outputs[i] = sum > layer.biases[i] ? 1 : 0
    end

    layer.outputs
  end
end
