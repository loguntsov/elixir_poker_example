defmodule Poker.Card do
  alias Poker.Card, as: Card

  defstruct value: nil, suit: nil

  def parse(<<value>> <> <<suit>> = card), do:
    %Card{ value: str_to_value(card), suit: suit(card) }

  def view(card), do:
    value_to_str(card.value) <> card.suit

  defp str_to_value(<<d>> <> _ ) do
    case <<d>> do
      "T" -> 10
      "J" -> 11
      "Q" -> 12
      "K" -> 13
      "A" -> 14
      _ when d > 49 and d <= 57 -> d - 48
    end
  end

  defp value_to_str(value) when value >= 1 and value <= 9,do:
    Integer.to_string(value)
  defp value_to_str(10), do: "T"
  defp value_to_str(11), do: "J"
  defp value_to_str(12), do: "Q"
  defp value_to_str(13), do: "K"
  defp value_to_str(14), do: "A"

  def suit(<<_>> <> <<suit>> <> "") do
    <<suit>>
  end
end
