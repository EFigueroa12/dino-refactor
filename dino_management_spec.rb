require_relative "dino_management"
require_relative "refactor_me"
require "benchmark"
require "rspec"

describe "Dino Management" do
  let(:dino_data) {[
    { "name"=>"DinoA", "category"=>"herbivore", "period"=>"Cretaceous", "diet"=>"plants", "age"=>100 },
    { "name"=>"DinoB", "category"=>"carnivore", "period"=>"Jurassic", "diet"=>"meat", "age"=>80 },
    { "name"=>"DinoC", "category"=>"herbivore", "period"=>"Cretaceous", "diet"=>"meat", "age"=>10 },
    { "name"=>"DinoD", "category"=>"carnivore", "period"=>"Jurassic", "diet"=>"plant", "age"=>1 },
    { "name"=>"DinoE", "category"=>"carnivore", "period"=>"Jurassic", "diet"=>"meat", "age"=>0 },
  ]}

  let(:large_dino_set) do Array.new(100000) do |i|
    { "name"=>"Dino#{i}", 
      "category"=> i.even? ? "carnivore" : "herbivore", 
      "period"=>"Jurassic", 
      "diet"=> i.even? ? "meat" : "plants", 
      "age"=>rand(1..100) }
    end
  end

  context "when using the optimized class methods" do
    describe "dino health calculation" do
      it "calculates dino health using age, category and diet" do
        result = DinoManagement.run(dino_data)
        expect(result[:dinos][0]['health']).to eq(0)
        expect(result[:dinos][1]['health']).to eq(20)
      end

      it "reduces health by half when category does not match diet" do
        result = DinoManagement.run(dino_data)
        expect(result[:dinos][2]['health']).to eq(45)
        expect(result[:dinos][3]['health']).to eq(99/2)
      end

      it "sets health to zero when age is less than or equal to 0" do
        result = DinoManagement.run(dino_data)
        expect(result[:dinos][4]['health']).to eq(0)
      end
    end

    describe "dino comment setting" do
      it "assigns appropriate comment based on health" do
        result = DinoManagement.run(dino_data)
        expect(result[:dinos][0]['comment']).to eq('Dead')
        expect(result[:dinos][1]['comment']).to eq('Alive')
      end
    end

    describe "dino age metric calculation" do
      it "computes age_metrics based on age and comment" do
        result = DinoManagement.run(dino_data)
        expect(result[:dinos][0]['age_metrics']).to eq(0)
        expect(result[:dinos][1]['age_metrics']).to eq(40)
      end

      it "sets metric to 0 if age is less than or equal to 1" do
        result = DinoManagement.run(dino_data)
        expect(result[:dinos][3]['age_metrics']).to eq(0)
        expect(result[:dinos][4]['age_metrics']).to eq(0)
      end
    end

    describe "dino category summary" do
      it "counts dinos by categories" do
        result = DinoManagement.run(dino_data)
        expect(result[:summary]).to eq({"herbivore"=>2, "carnivore"=>3})
      end

      it "returns an empty summary when no dinos exist" do
        result = DinoManagement.run([])
        expect(result[:summary]).to eq({})
      end

      it "handles large dino datasets efficiently" do 
        result = DinoManagement.run(large_dino_set)
        expect(result[:dinos].size).to eq(100000)
        expect(result[:summary]).to have_key("herbivore")
        expect(result[:summary]).to have_key("carnivore")
      end
    end

    describe "Dino performance comparison" do
      it "compares performance of old and new code" do
        old_time = Benchmark.realtime do 
        run(large_dino_set.dup)
        end
        new_time = Benchmark.realtime do
        result = DinoManagement.run(large_dino_set.dup)
        end

        puts "\nUnoptimized code: #{old_time.round(5)} seconds."
        puts "Optimized code: #{new_time.round(5)} seconds."
    
        expect(new_time).to be < old_time
      end
    end
  end
end
