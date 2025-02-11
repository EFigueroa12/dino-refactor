class Dino()
    attr_accessor :name, :category, :period, :diet, :age, :health, :comment, :age_metrics

    def init_dino(name:, category:, period:, diet:, age:)
        @name = name
        @category = category
        @period = period
        @diet = diet
        @age = age
        @health = 0
        @comment = ''
        @age_metrics = 0
    end

    def calculate_health
        return @health = 0 if @age <= 0 
        base_health = (100 - @age)
        @health = (@category=='herbivore' and @diet=='plants') || 
                    (@category=='carnivore' and @diet=='meat') ? base_health : base_health / 2
    end

    def set_comment
        @comment = @health > 0 ? 'Alive' : 'Dead'
    end

    def calculate_age_metric
        return @age_metrics = 0 if @comment == 'Dead'
        @age_metrics = @age > 1 ? (@age/ 2).to_i : 0
    end
