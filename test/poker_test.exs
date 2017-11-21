defmodule PokerTest do
  use ExUnit.Case
  doctest Poker

  test "poker game test" do
    assert {:white, {:high_card, 14}} == Poker.game("2H 3D 5S 9C KD", "2C 3H 4S 8C AH")
    assert {:white, {:flush, 14}} == Poker.game("2H 4S 4C 3D 4H", "2S 8S AS QS 3S")
    assert {:black, {:high_card, 9}} = Poker.game("2H 3D 5S 9C KD", "2C 3H 4S 8C KH")
    assert :tie == Poker.game("2H 3D 5S 9C KD", "2D 3H 5C 9S KH")
  end
end
