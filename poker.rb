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

$rev_value_dict = {
    "2" => "2",
    "3" => "3",
    "4" => "4",
    "5" => "5",
    "6" => "6",
    "7" => "7",
    "8" => "8",
    "9" => "9",
    "10" => "10:",
    "11" => "Jack",
    "12" => "Queen",
    "13" => "King",
    "14" => "Ace"
}

$p1_hand_counter = {
    "2" => 0,
    "3" => 0,
    "4" => 0,
    "5" => 0,
    "6" => 0,
    "7" => 0,
    "8" => 0,
    "9" => 0,
    "10" => 0
}
$p2_hand_counter = {
    "2" => 0,
    "3" => 0,
    "4" => 0,
    "5" => 0,
    "6" => 0,
    "7" => 0,
    "8" => 0,
    "9" => 0,
    "10" => 0
}
$aFile = File.new("output.txt", "r+")

class Card
    # Card class. Each card will be an instance of this class
    attr_reader :value
    attr_reader :suit

    def initialize(str)
        @rank = str[0]
        @suit = str[1]
        @value =  @rank.to_i == 0 ? $value_dict[@rank.to_sym] : @rank.to_i
    end

    def display_card
        $aFile.syswrite( "Rank: #{@rank}, Suit: #{@suit}, Value is #{@value}\n")
    end
end

class Hand
    #Hand class. Each hand will hold an array of card objects as well as
    # additional information about the hand. 
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
        # determines how many cards in a hand repeat themselves
        @counter = {}
        @hand[0..4].each {|card|
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
        # determines the primary hand type
        if @hand.length > 5
            return @hand
        end
        flush_check = self.is_flush?
        straight_check = self.is_straight?
        repeats = self.repeat_counter

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


    end
end

def secondary_compare(h1, h2)
    #compares high cards, straights, flushes if the primary comparison fails
    if (h1.ranked_hand == 1 || h1.ranked_hand == 5 ||
     h1.ranked_hand == 6 || h1.ranked_hand == 8)
    highest_card_one = h1.hand[4].value
    highest_card_two = h2.hand[4].value

     $aFile.syswrite("P1's highest card is #{$rev_value_dict[highest_card_one.to_s]} || ")
     $aFile.syswrite("P2's highest card is #{$rev_value_dict[highest_card_two.to_s]}\n")
        if highest_card_one > highest_card_two
            $aFile.syswrite("Winner: P1\n")
            $aFile.syswrite("\n")
            return 1
        elsif highest_card_one < highest_card_two
            $aFile.syswrite("Winner: P2\n")
            $aFile.syswrite("\n")
            return -1
        else
            highest_card_one = h1.hand[3].value
            highest_card_two = h2.hand[3].value
            $aFile.syswrite("P1's second highest card is #{$rev_value_dict[highest_card_one.to_s]} || ")
            $aFile.syswrite("P2's second highest card is #{$rev_value_dict[highest_card_two.to_s]}\n")
            last_chance = highest_card_one <=> highest_card_two
            if last_chance == 1
                $aFile.syswrite( "Winner: P1\n")
                $aFile.syswrite("\n")
                return 1
            elsif last_chance == -1
                $aFile.syswrite( "Winner: P2\n")
                $aFile.syswrite("\n")
                return -1    
            else
                highest_card_one = h1.hand[2].value
                highest_card_two = h2.hand[2].value
                $aFile.syswrite("P1's third highest card is #{$rev_value_dict[highest_card_one.to_s]} || ")
                $aFile.syswrite("P2's third highest card is #{$rev_value_dict[highest_card_two.to_s]}\n")
                last_chance = highest_card_one <=> highest_card_two
                if last_chance == 1
                    $aFile.syswrite( "Winner: P1\n")
                    $aFile.syswrite("\n")
                    return 1
                elsif last_chance == -1
                    $aFile.syswrite( "Winner: P2\n")
                    $aFile.syswrite("\n")
                return -1    
                else
                    $aFile.syswrite( "Tie!\n") 
                    $aFile.syswrite("\n")
                end
                return 0    
            end                    
        end        
    else
        return compare_repeating(h1, h2)

    end
end

def compare_repeating(h1, h2)
    #compares pairs, triples, full houses
    dict_one = h1.counter
    dict_two = h2.counter
    max_repeat = dict_one.max_by{|k, v| v}

    highest_card_1 = dict_one.key(max_repeat[1])
    highest_card_2 = dict_two.key(max_repeat[1])
    result = 0
    $aFile.syswrite( "P1's highest card is #{$rev_value_dict[highest_card_1.to_s]}\n")
    $aFile.syswrite( "P2's highest card is #{$rev_value_dict[highest_card_2.to_s]}\n")
    result = highest_card_1 <=> highest_card_2
    if result == 1
        $aFile.syswrite( "Winner: P1\n")
        $aFile.syswrite("\n")
    elsif result == -1
        $aFile.syswrite( "Winner: P2\n")
        $aFile.syswrite("\n")
    else 
        $aFile.syswrite( "Tie\n")
        $aFile.syswrite("\n")
    end
    return result 

end

            

def compare(h1, h2)
    # Compares based on primary hand (straight, flush etc)
    # If comparison fails, passes to anothor function for a finer comparison
    h1_rank = h1.ranked_hand


    if $p1_hand_counter.has_key?(h1_rank.to_s)
        $p1_hand_counter[h1_rank.to_s] += 1
    else
        $p1_hand_counter[h1_rank.to_s] = 1
    end

    h2_rank = h2.ranked_hand

    if $p2_hand_counter.has_key?(h2_rank.to_s)
        $p2_hand_counter[h2_rank.to_s] += 1
    else
        $p2_hand_counter[h2_rank.to_s] = 1
    end


    $aFile.syswrite("P1: #{$hand_type[h1_rank.to_s]} || ")
    $aFile.syswrite("P2: #{$hand_type[h2_rank.to_s]}\n")

    if h1_rank > h2_rank
        $aFile.syswrite( "Winner: P1\n")
        $aFile.syswrite("\n")
        return 1
    elsif h1_rank < h2_rank
        $aFile.syswrite( "Winner: P2\n")
        $aFile.syswrite("\n")
        return -1
    else
        return secondary_compare(h1, h2)
    end

end

def get_input
    # Gets input and tally's results
    arr = IO.readlines("poker.txt")
    stats = []
    test_case = 1
    for pair in arr
        $aFile.syswrite( "Test Case # #{test_case}:\n")
        test_case += 1
        $aFile.syswrite( pair[0..14]+ " || "  + pair[15..29])

        h1 = Hand.new(pair[0..14])
        h2 = Hand.new(pair[15..29])
        stats.push(compare(h1, h2))

    end
    $aFile.syswrite("---------------------------------------------------------\n")
    $aFile.syswrite("---------------------------------------------------------\n")
    $aFile.syswrite("Player 1 won #{stats.count(1)} hands\n")
    $aFile.syswrite("Player 2 won #{stats.count(-1)} hands\n")
    $aFile.syswrite("Hands won by neiher player: #{stats.count(0)}\n")

    $aFile.syswrite("\nTotal hands Player 1 || Player 2:\n")
    $aFile.syswrite("High Card.....: #{$p1_hand_counter[1.to_s]} || #{$p2_hand_counter[1.to_s]}\n")
    $aFile.syswrite("Pair..........: #{$p1_hand_counter[2.to_s]} || #{$p2_hand_counter[2.to_s]}\n")
    $aFile.syswrite("Two Pairs......: #{$p1_hand_counter[3.to_s]} || #{$p2_hand_counter[3.to_s]}\n")
    $aFile.syswrite("Three of a kind: #{$p1_hand_counter[4.to_s]} || #{$p2_hand_counter[4.to_s]}\n")
    $aFile.syswrite("Straight.......: #{$p1_hand_counter[5.to_s]} || #{$p2_hand_counter[5.to_s]}\n")
    $aFile.syswrite("Flush...........: #{$p1_hand_counter[6.to_s]} || #{$p2_hand_counter[6.to_s]}\n")
    $aFile.syswrite("Full House:...... #{$p1_hand_counter[7.to_s]} || #{$p2_hand_counter[7.to_s]}\n")
    $aFile.syswrite("Four of a Kind..: #{$p1_hand_counter[8.to_s]} || #{$p2_hand_counter[8.to_s]}\n")
    $aFile.syswrite("Straight Flush..: #{$p1_hand_counter[9.to_s]} || #{$p2_hand_counter[9.to_s]}\n")

end

if __FILE__ == $0
    $aFile.syswrite("Please scroll all the way to the end for summary!\n\n")
    get_input
    puts "Please check output.txt in current directory"
end




