defmodule Poker.Hand do
  @moduledoc false

  def sort(hand) do
    hand
      |> Enum.sort(fn card ->
        Poker.Card.value(card)
      end)
      |> Enum.reverse()
  end

  def values(hand) do
    hand
      |> Enum.map(fn(card) -> card.value end)
      |> Enum.sort()
      |> Enum.reverse()
  end
  
end
