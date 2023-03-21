require_relative "./ship"

class Population
  attr_reader :max_fit, :gen_no
    def initialize(size)
        @size = size
        @fleet = []
        @genes = []
        @total_damaged = 0
        @total_succeeded = 0
        @gen_no = 1
        @max_fit = 0
        init_ships(size)
    end

    def init_ships(size)
        @fleet = Array.new(size) { Ship.new }
    end

    def success_rate
      (@total_succeeded.to_f / @size ) * 100
    end

    def ship_model
      @fleet.reject(&:damaged)[0]
    end

    def next_generation
      @max_fit = get_max_fitness

      collect_genes 
      
      @fleet.each {|ship| ship.destroy}
      @fleet.each_with_index do |ship, i|
        ship.respawn
        if i < @size - 5
          ship.clone_gene(@genes.sample)
        else 
          ship.new_gene
        end
      end
      @gen_no += 1
    end
      
    def collect_genes
      @genes = []
      @fleet.each do |ship|
        @genes += [ship.gene] * (100 * (ship.fitness / @max_fit)).round
      end
      # puts @genes.length
    end

    def update(borders, asteroids)
      @total_damaged = 0
      @fleet.each do |ship|
        ship.draw
        ship.update(borders, asteroids)
        if ship.damaged
          @total_damaged += 1
          ship.destroy 
        end
      end
    end

    def all_destroyed?
      @total_damaged >= @fleet.length
    end

    def get_max_fitness
      max_fit = 0
      @total_succeeded = 0
      @fleet.each do |ship|
        ship.evaluate_fitness
        max_fit = ship.fitness if ship.fitness > max_fit
        @total_succeeded += 1 if ship.success
      end
      max_fit
    end
        
end