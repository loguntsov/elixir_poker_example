defmodule Poker do

  def game(black, white) do
    case game([ black, white ]) do
      nil -> :tie
      { 0, result } -> { :black, result }
      { 1, result } -> { :white, result }
    end
  end

  def game(hands) do
    hands
      |> Enum.map(&parse/1)
      |> Poker.Hand.Position.compare()
  end

  def parse(str) do
    str = String.replace(str, [" ", "-", "," ], "")
    parse(str, [])
  end

  defp parse(<<a, b>> <> c, acc), do:
    parse(c, [ Poker.Card.parse(<<a, b>>) | acc ])
  defp parse("", acc), do: acc

end
