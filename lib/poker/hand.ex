defmodule Poker.Hand do
  @moduledoc false

  def values(hand) do
    hand
      |> Enum.map(fn(card) -> card.value end)
      |> Enum.sort()
      |> Enum.reverse()
  end
  
end
