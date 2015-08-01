require_relative "poker" #!/usr/bin/env ruby -wKU
require 'test/unit'
extend Test::Unit::Assertions

$aFile = File.new("output_test.txt", "r+")
c1 = Card.new("QH")
c1.display_card








class TestSimpleNumber < Test::Unit::TestCase
    def test_method
        h2 = Hand.new("4C TS KC 9H 4S")
        h3 = Hand.new("5C AD 5D AC 9C")

        h1 = Hand.new("2H 2S 5H 5D 2C")
        h1.hand_assign
        #assert_equal(7, h1.ranked_hand)
        assert(0, compare(h2, h3))

    end
end


