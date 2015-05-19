$hand_type = {
    "1"=> "High Card",
    "2"=> "Pair",
    "3"=> "Two Pairs",
    "4"=> "Three of a Kind",
    "5"=> "Straight",
    "6"=> "Flush",
    "7"=> "Full House",
    "8"=> "Four of a Kind",
    "9"=> "Straight Flush",
    "10"=> "Royal Flush"
}

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
    def initialize(str)
        @arr = str.split(" ")

        @hand = []
        @arr.each {|x| @hand.push(Card.new(x)) }
        @hand.sort! {|x, y| x.value <=> y.value }
    end

    def show_hand
        @hand.each {|x| x.display_card}
    end

    def is_flush?
        suit_value = @hand[0].suit
        @hand[1..4].each {|x|
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
        @hand[1..4].each {|card|
            # if card.is_i
            #     pass
            if counter.has_key?(card.value)
                counter[card.value] += 1
            else
                counter[card.value] = 1
            end
        }
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
        if @hand.length > 5
            return @hand
        end
        flush_check = self.is_flush?
        straight_check = self.is_straight?
        repeats = self.repeat_counter

        if flush_check && straight_check && @hand[4].value == 14
            @hand.push(10)
        elsif flush_check && straight_check
            @hand.push(9)
        elsif flush_check
            @hand.push(6)
        elsif straight_check
            @hand.push(5)
        elsif repeats == [3,2]
            @hand.push(7)
        elsif repeats == [4]
            @hand.push(8)
        elsif repeats == [3]
            @hand.push(4)
        elsif repeats == [2,2]
            @hand.push(3)
        elsif repeats == [2]
            @hand.push(2)
        else
            @hand.push(1)
        end
        return @hand
    end

end

def compare(h1, h2)
    h1_rank = h1.hand_assign[5]
    h2_rank = h2.hand_assign[5]
    puts

    puts "H1: #{$hand_type[h1_rank.to_s]}"
    puts "H2: #{$hand_type[h2_rank.to_s]}"

    if h1_rank > h2_rank
        return 1
    elsif h1_rank < h2_rank
        return -1
    else
        return 0
    end

end

def get_input
    #text = File.new("poker.txt")
    arr = IO.readlines("poker.txt")
    stats = []
    for pair in arr
        h1 = Hand.new(pair[0..14])
        h2 = Hand.new(pair[15..29])
        stats.push(compare(h1, h2))

    end
    puts stats.count(1)
    puts stats.count(-1)
    puts stats.count(0)


    #puts h2
    

end

get_input

# c1 = Card.new("KC")
# c2 = Card.new("AC")

# c1.display_card
# c2.display_card

# h1 = Hand.new("5S 3C 4C 5S 4S")
# h2 = Hand.new("8C 9C TC JC QC")
# h3 = Hand.new("TS JS QS KS AS")
# h4 = Hand.new("8S TS 8C TD 8H")

# h1.show_hand
# h2.show_hand
# h3.show_hand
# h4.show_hand


# puts 1, "Flush? #{h1.is_flush?} Straight? #{h1.is_straight?}" #false
# puts 2, "Flush? #{h2.is_flush?} Straight? #{h2.is_straight?}" #true
# puts 3, "Flush? #{h3.is_flush?} Straight? #{h3.is_straight?}" #false
# puts 4, "Flush? #{h4.is_flush?} Straight? #{h4.is_straight?}" #true

#puts" result is #{h1.repeat_counter}"
# puts h1.hand_assign[5] #3
# puts h2.hand_assign[5] #9
# puts h3.hand_assign[5] #10
# puts h4.hand_assign[5] #7

# compare(h3, h2)
# compare(h3, h4)
# compare(h1, h2)
# compare(h3, h2)

