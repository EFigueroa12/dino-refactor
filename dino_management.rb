# My Dino Management 
class DinoManagement
  def self.run(dinos)
    raise ArgumentError, "Input must be an array of dinos" unless dinos.is_a?(Array)
    { dinos: [], summary: {} } if dinos.empty?

    dinos.each do |dino|
      calculate_health(dino)
      set_comment(dino)
      calculate_age_metric(dino)
    end

      summary = generate_summary(dinos)
      { dinos: dinos, summary: summary}
  end

  private

  def self.calculate_health(dino)
    base_health = (100 - dino['age'])
    dino['health'] = if dino['age'] <= 0
                       0
                     else
                (dino['category'] == 'herbivore' && dino['diet'] == 'plants') || 
                (dino['category'] == 'carnivore' && dino['diet'] == 'meat') ? base_health : base_health / 2
                     end
  end

  def self.set_comment(dino)
    dino['comment'] = dino['health'] > 0 ? 'Alive' : 'Dead'
  end

  def self.calculate_age_metric(dino)
    dino['age_metrics'] = dino['comment'] == 'Dead' ? 0 : (dino['age'] > 1 ? (dino['age'] / 2) : 0)
  end

  def self.generate_summary(dinos)
    dinos.group_by { |d| d['category'] }.transform_values(&:count)
  end
end


# data = [
#         { "name"=>"DinoA", "category"=>"herbivore", "period"=>"Cretaceous", "diet"=>"plants", "age"=>100 },
#         { "name"=>"DinoB", "category"=>"carnivore", "period"=>"Jurassic", "diet"=>"meat", "age"=>80 }
#         ]
# dinfo = DinoManagement.run(data)
# puts dinfo