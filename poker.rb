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

$value_dict = {
    T: 10,
    J: 11,
    Q: 12,
    K: 13,
    A: 14
}

# $rev_value_dict = {
#     :11 => "Jack",
#     :12 => "Queen",
#     :13 => "King",
#     :14 => "Ace"
# }

class Card

    attr_reader :value
    attr_reader :suit

    def initialize(str)
        @rank = str[0]
        @suit = str[1]
        @value =  @rank.to_i == 0 ? $value_dict[@rank.to_sym] : @rank.to_i
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
        @ranked_hand = 0
        hand_assign
    end
    attr_reader :hand
    attr_reader :ranked_hand
    attr_reader :counter

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
        @counter = {}
        @hand[1..4].each {|card|
            # if card.is_i
            #     pass
            if @counter.has_key?(card.value)
                @counter[card.value] += 1
            else
                @counter[card.value] = 1
            end
        }
        result_array = []
        for k, v in @counter
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

        #@hand.type = ROYAL_FLUSH;

        if flush_check && straight_check && @hand[4].value == 14
            @ranked_hand = 10
        elsif flush_check && straight_check
            @ranked_hand = 9
        elsif flush_check
            @ranked_hand = 6
        elsif straight_check
            @ranked_hand = 5
        elsif repeats == [3,2]
            @ranked_hand = 7
        elsif repeats == [4]
            @ranked_hand = 8
        elsif repeats == [3]
            @ranked_hand = 4
        elsif repeats == [2,2]
            @ranked_hand = 3
        elsif repeats == [2]
            @ranked_hand = 2
        else
            @ranked_hand = 1
        end
        #puts @ranked_hand

    end
end

def secondary_compare(h1, h2)
    if (h1.ranked_hand == 1 || h1.ranked_hand == 5 ||
     h1.ranked_hand == 6 || h1.ranked_hand == 8)
    highest_card_one = h1.hand[4].value
    highest_card_two = h2.hand[4].value
    # puts highest_card_one
    # puts highest_card_two


     print "P1 highest card is #{highest_card_one} || "
     print "P2 highest card is #{highest_card_two}" 
     puts  
        if highest_card_one > highest_card_two
            puts "Winner: P1"
            puts
            return 1
        elsif highest_card_one < highest_card_two
            puts "Winner: P2"
            puts
            return -1
        else
            highest_card_one = h1.hand[3].value
            highest_card_two = h2.hand[3].value
            puts "Tie!"
            last_chance = highest_card_one <=> highest_card_two
            if last_chance == 0
                puts "Winner: P1"
                puts
                return 1
            elsif last_chance == -1
                puts "Winner: P2"
                puts
                return -1    
            else
                puts "Tie!" 
                puts 
                return 0    
            end      
                    
        end        
    else
        return compare_repeating(h1, h2)

    end
end

def compare_repeating(h1, h2)
    dict_one = h1.counter
    dict_two = h2.counter
    max_repeat = dict_one.max_by{|k, v| v}
    #puts "Max repeat is #{max_repeat}"
    highest_card_1 = dict_one.key(max_repeat[1])
    highest_card_2 = dict_two.key(max_repeat[1])
    result = 0
    puts "P1's highest card is #{highest_card_1}"
    puts "P2's highest card is #{highest_card_2}"
    result = highest_card_1 <=> highest_card_2
    if result == 1
        puts "Winner: P1"
        puts
    elsif result == -1
        puts "Winner: P2"
        puts
    else 
        puts "Tie"
        puts
    end
    return result 

end

            

def compare(h1, h2)
    #puts
    h1_rank = h1.ranked_hand
    #puts "rank is #{h1_rank}"
    h2_rank = h2.ranked_hand
    #puts "rank is #{h2_rank}"
    #puts

    print "P1: #{$hand_type[h1_rank.to_s]} || "
    print "P2: #{$hand_type[h2_rank.to_s]}"
    puts

    if h1_rank > h2_rank
        puts "Winner: P1"
        puts
        return 1
    elsif h1_rank < h2_rank
        puts "Winner: P2"
        puts
        return -1
    else
        return secondary_compare(h1, h2)
        puts
    end

end

def get_input
    #text = File.new("poker.txt")
    arr = IO.readlines("poker.txt")
    stats = []
    test_case = 1
    for pair in arr
        puts "Test Case # #{test_case}:"
        test_case += 1
        puts pair

        h1 = Hand.new(pair[0..14])
        h2 = Hand.new(pair[15..29])
        # h1.show_hand
        # h2.show_hand
        stats.push(compare(h1, h2))

    end
    puts stats.count(1)
    puts stats.count(-1)
    puts stats.count(0)

    
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

