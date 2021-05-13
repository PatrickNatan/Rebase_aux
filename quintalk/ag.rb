POPULATION = 100
GENES = '''abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOP
QRSTUVWXYZ 1234567890, .-;:_!"#%&/()=?@${[]}'''
TARGET = 'REBASE'

def create_gnome
  TARGET.split('').map { GENES.split('').sample }
end

class Individual
  attr_reader :chromosome, :fitness

  def initialize(chromosome)
    @chromosome = chromosome
    @fitness = cal_fitness
  end

  def mate(other_individual)
    child_chromosome = []
    chromosome.zip(other_individual.chromosome).each do |gp1, gp2|
      prob = Random.random_number
      child_chromosome << if prob < 0.45
                            gp1
                          elsif prob < 0.90
                            gp2
                          else
                            mutated_gens
                          end
    end
    Individual.new(child_chromosome)
  end

  private

  def mutated_gens
    GENES.split('').sample
  end

  def cal_fitness
    fitness = 0
    chromosome.zip(TARGET.split('')).each do |gs, gt|
      fitness += 1 if gt != gs
    end
    fitness
  end
end

### CRIANDO A POPULAÇÃO
generation = 1
found = false
population = []

POPULATION.times do
  gnome = create_gnome
  population << Individual.new(gnome)
end
###

until found
  population = population.sort_by(&:fitness)
  if population[0].fitness <= 0 # pediu pra parar parou
    found = !found
    break
  end
  new_generation = []
  elite = ((10 * POPULATION) / 100).ceil
  new_generation = population.first(elite)
  new_population_size = ((90 * POPULATION) / 100).ceil

  new_population_size.times do
    parent1 = population.first(50).sample
    parent2 = population.first(50).sample
    child = parent1.mate(parent2)
    new_generation << child
  end
  population = new_generation

  puts "GERAÇÃO #{generation} | STRING: #{population[0].chromosome.join} | FITNESS: #{population[0].fitness} "
  generation = generation += 1
end

puts "GERAÇÃO #{generation} | STRING: #{population[0].chromosome.join} | FITNESS: #{population[0].fitness} "
