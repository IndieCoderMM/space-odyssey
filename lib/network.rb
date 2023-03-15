require_relative './layer'

class NeuralNetwork
  attr_reader :layers

  def initialize(neuron_counts)
    @layers = []
    (0...neuron_counts.length - 1).each do |i|
      @layers.push(Layer.new(neuron_counts[i], neuron_counts[i + 1]))
    end
    puts @layers[0].inputs.length
  end

  def self.feed_forward(inputs, network)
    outputs = Layer.feed_forward(inputs, network.layers[0])

    (1...network.layers.length).each do |i|
      outputs = Layer.feed_forward(outputs, network.layers[i])
    end

    outputs
  end
end
