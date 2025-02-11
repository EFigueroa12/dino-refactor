# This is a poorly written code for the management of dinos.
# The purpose of this code is to serve as a refactor test for
# candidates applying for a software engineer position at our company.
# We expect you to refactor it and turn it into an efficient
# and maintainable code, following best practices. Fill in the Rspect test as well, modify it to your liking,
# we do want to see some decent testing.
# Please don't spend too much time on this, we know your time is valuable and we want to
# make this fun but also allow you to show off your ruby skills :)
#
# Existing data: [
#   { "name"=>"DinoA", "category"=>"herbivore", "period"=>"Cretaceous", "diet"=>"plants", "age"=>100 },
#   { "name"=>"DinoB", "category"=>"carnivore", "period"=>"Jurassic", "diet"=>"meat", "age"=>80 }
# ]
#

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


data = [
          { "name"=>"DinoA", "category"=>"herbivore", "period"=>"Cretaceous", "diet"=>"plants", "age"=>100 },
          { "name"=>"DinoB", "category"=>"carnivore", "period"=>"Jurassic", "diet"=>"meat", "age"=>80 }
        ]
dinfo = run(data)

puts dinfo

require_relative "dino_management"
require "rspec"

describe "Dino Management" do
  let(:dino_data) { [
    { "name"=>"DinoA", "category"=>"herbivore", "period"=>"Cretaceous", "diet"=>"plants", "age"=>100 },
    { "name"=>"DinoB", "category"=>"carnivore", "period"=>"Jurassic", "diet"=>"meat", "age"=>80 },
    { "name"=>"DinoC", "category"=>"herbivore", "period"=>"Cretaceous", "diet"=>"meat", "age"=>10 },
    { "name"=>"DinoD", "category"=>"carnivore", "period"=>"Jurassic", "diet"=>"plant", "age"=>1 },
    { "name"=>"DinoE", "category"=>"carnivore", "period"=>"Jurassic", "diet"=>"meat", "age"=>0 },
  ] }

  context "when using the long and unoptimized method" do
    describe "dino health calculation" do
      it "calculates dino health using age, category and diet" do
        # Fill in expectations here
        result = run(dino_data)
        expect(result[:dinos][0]['health']).to eq(0)
        expect(result[:dinos][1]['health']).to eq(20)
      end

      it "reduces health by half when category does not match diet" do
        result = run(dino_data)
        expect(result[:dinos][2]['health']).to eq(45)
        expect(result[:dinos][3]['health']).to eq(99/2)
      end

      it "sets health to zero when age is less than or equal to 0" do
        result = run(dino_data)
        expect(result[:dinos][4]['health']).to eq(0)
      end
    end

    describe "dino comment setting" do
      it "assigns appropriate comment based on health" do
        # Fill in expectations here
        result = run(dino_data)
        expect(result[:dinos][0]['comment']).to eq('Dead')
        expect(result[:dinos][1]['comment']).to eq('Alive')
      end
    end

    describe "dino age metric calculation" do
      it "computes age_metrics based on age and comment" do
        # Fill in expectations here
        result = run(dino_data)
        expect(result[:dinos][0]['age_metrics']).to eq(0)
        expect(result[:dinos][1]['age_metrics']).to eq(40)
      end

      it "sets metric to 0 if age is less than or equal to 1" do
        result = run(dino_data)
        expect(result[:dinos][3]['age_metrics']).to eq(0)
        expect(result[:dinos][4]['age_metrics']).to eq(0)
      end
    end

    describe "dinos returned" do
      it "returns the same dino input data" do
        result = run(dino_data)
        expect(result[:dinos]).to eq(dino_data)
      end
    end

    describe "dino category summary" do
      it "counts dinos by categories" do
        # Fill in expectations here
        result = run(dino_data)
        expect(result[:summary]).to eq({"herbivore"=>2, "carnivore"=>3})
      end
    end
  end
end


