class Card
    @@value_dict = {
        T: 10,
        J: 11,
        Q: 12,
        K: 13,
        A: 14
    }
    attr_reader :value
    attr_reader :suit

    def initialize(str)
        @rank = str[0]
        @suit = str[1]
        @value =  @rank.to_i == 0 ? @@value_dict[@rank.to_sym] : @rank.to_i
    end

    def display_card
        puts "Rank: #{@rank}, Suit: #{@suit}, Value is #{@value}"
    end
end

class Hand

    @@hand_type = {
        high_card: 1,
        pair: 2,
        two_pair: 3,
        three_of_a_kind: 4,
        straight: 5,
        flush: 6,
        full_house: 7,
        four_of_a_kind: 8,
        straight_flush: 9,
        royal_flush: 10
    }

    def initialize(str)
        @arr = str.split(" ")
        puts @arr
        @hand = []
        @arr.each {|x| @hand.push(Card.new(x)) }
        @hand.sort! {|x, y| x.value <=> y.value }
    end

    def show_hand
        @hand.each {|x| x.display_card}
    end

    def is_flush?
        suit_value = @hand[0].suit
        @hand[1..-1].each {|x|
            if x.suit != suit_value
                return false
            end
        }
        return true
    end

    def is_straight?
        if @hand[4].value - @hand[0].value == 4
            return true
        else
            return false
        end
    end

    def repeat_counter
        counter = {}
        for card in @hand
            if counter.has_key?(card.value)
                counter[card.value] += 1
            else
                counter[card.value] = 1
            end
        end
        result_array = []
        for k, v in counter
            if v > 1
                result_array.push(v)
            end
        end
        result_array.sort! {|a, b| b <=> a}
        return result_array
    end

    def hand_assign
        flush_check = self.is_flush?
    end

end


c1 = Card.new("KC")
c2 = Card.new("AC")

# c1.display_card
# c2.display_card

h1 = Hand.new("5S 5C 4C 5S 4S")
h2 = Hand.new("8C 9C TC JC QC")
h3 = Hand.new("TS JS QC KS AS")
h4 = Hand.new("8S TS KS 9S 4S")

h1.show_hand
h2.show_hand
h3.show_hand
h4.show_hand


puts 1, "Flush? #{h1.is_flush?} Straight? #{h1.is_straight?}" #false
puts 2, "Flush? #{h2.is_flush?} Straight? #{h2.is_straight?}" #true
puts 3, "Flush? #{h3.is_flush?} Straight? #{h3.is_straight?}" #false
puts 4, "Flush? #{h4.is_flush?} Straight? #{h4.is_straight?}" #true

puts" result is #{h1.repeat_counter}"
puts h2.hand_assign

