# Provided function
def run(dinos)
    dinos.each do |d|
      if d['age'] > 0
        if d['category'] == 'herbivore'
          d['health'] = d['diet'] == 'plants' ? (100 - d['age']) : (100 - d['age']) / 2
        else
          if d['category'] == 'carnivore'
            d['health'] = d['diet'] == 'meat' ? (100 - d['age']) : (100 - d['age']) / 2
          end
        end
      else
        d['health'] = 0
      end
  
      if d['health'] > 0
        d['comment'] = 'Alive'
      else
        d['comment'] = 'Dead'
      end
    end
  
    dinos.each do |d|
      if d['comment'] == 'Alive'
        if d['age'] > 1
          d['age_metrics'] = (d['age'] / 2).to_i
        else
          d['age_metrics'] = 0
        end
      else
        d['age_metrics'] = 0
      end
    end
  
    if dinos && dinos.length > 0
      a = dinos.group_by { |d| d['category'] }.map do |category, dino_list|
        { category: category, count: dino_list.count }
      end
    end
  
    f = {}
    a.each do |category_metrics|
      f[category_metrics[:category]] = category_metrics[:count]
    end
  
    return { dinos: dinos, summary: f }
end
  
# My optimized version
def my_run(dinos)
    dinos.each do |d|
        if d['age'] > 0
        base_health = (100 - d['age'])
        if ['herbivore', 'carnivore'].include?(d['category'])
            d['health'] = (d['category']=='herbivore' and d['diet']=='plants') || 
                            (d['category']=='carnivore' and d['diet']=='meat') ? base_health : base_health / 2
        end
        if d['health'] && d['health'] > 0
            d['comment'] = 'Alive' 
            d['age_metrics'] = d['age'] > 1 ? (d['age']/ 2).to_i : 0
        else 
            d['comment'] = 'Dead'
            d['age_metrics'] = 0
        end
        else
        d['health'] = 0
        d['comment'] = 'Dead'
        d['age_metrics'] = 0
        end
    end

    f = {}
    if dinos && !dinos.empty?
        f = dinos.group_by{ |d| d['category']}.transform_values(&:count)
    end

    return { dinos: dinos, summary: f }
end

data = [
        { "name"=>"DinoA", "category"=>"herbivore", "period"=>"Cretaceous", "diet"=>"plants", "age"=>100 },
        { "name"=>"DinoB", "category"=>"carnivore", "period"=>"Jurassic", "diet"=>"meat", "age"=>80 }
        ]
dinfo = run(data)

puts dinfo

dinfo2 =my_run(data)
puts dinfo2 #sameoutput as dinfo in run