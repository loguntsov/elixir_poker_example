defmodule Poker.Hand.Position do
  @moduledoc false

  def compare(hands_list) do
    indexed = Enum.with_index(hands_list)
    r = [ &get_straight_flush/1, &get_4_kind/1, &get_full_house/1, &get_flush/1, &get_straight/1, &get_3_kind/1, &get_2_pair/1, &get_pair/1 ]
      |> List.foldl(nil, fn
        ( check_fn, nil) ->
          #IO.puts("#{inspect n}")
          indexed |> List.foldl(nil, fn
            {hand, index}, nil ->
              case check_fn.(hand) do
                [] -> nil;
                [a | _ ] -> { index, a }
              end
            {hand, index}, { _, r } = result ->
              case check_fn.(hand) do
                [] -> result;
                [ a | _ ] ->
                  cond do
                     a > r -> { index, a }
                     a == r -> :nil
                     true -> result
                  end   
              end
          end)
        ;(_, result) -> result end
      )
    case r do
      nil -> get_high_card(hands_list)
      r -> r
    end
  end

  def value(:high_card), do: 0
  def value(:pair), do: 1
  def value(:pair2), do: 2
  def value(:kind3), do: 3
  def value(:straight), do: 4
  def value(:flush), do: 5
  def value(:full_house), do: 6
  def value(:kind4), do: 7
  def value(:straight_flush), do: 8

  def get_high_card(hands) do
    r = hands
      |> Enum.map(&(Poker.Hand.values(&1)))
      |> Enum.zip()
      |> Enum.map(&(&1 |> Tuple.to_list() |> Enum.with_index() |> Enum.sort()))
      |> List.foldl([], fn
        ( max_cards, []) -> get_high_card(max_cards, [])
        (_, result) -> result
      end)
    case r do
      [] -> nil
      [{ v, i }] -> { i, {:high_card, v }}
    end
  end

  defp get_high_card([{v1, _}, {v2, _} = r2 | tail ], acc) when v1 < v2, do:
    get_high_card([ r2 | tail ], acc)
  defp get_high_card([{v, _}, {v, _}], acc ), do: acc
  defp get_high_card([r2], acc), do: [ r2 | acc ]

  def get_straight_flush(hand) do
    hand
      |> Enum.group_by(fn(card) -> card.suit end)
      |> Enum.flat_map(fn({ _, group}) ->
        group0 = group |> Poker.Hand.values()
        case { get_flush(group0, []), get_straight(group0, []) } do
          {[{:flush, _ } | _ ], [ { :straight, v } | _ ]} -> [{ :straight_flush, v }]
          _ -> []
        end
      end)
  end

  def get_4_kind(hand) do
    hand
      |> Poker.Hand.values()
      |> get_4_kind([])
  end

  def get_full_house(hand) do
    case get_3_kind(hand) do
      [{ :kind3, v2 }| _ ] ->
        last = hand |> Enum.filter(&(&1.value != v2))
        case get_pair(last) do
          [{ :pair, _ } | _ ] -> [{ :full_house, v2 }]
          _ -> []
        end
      _ -> []
    end
  end

  def get_flush(hand) do
    hand
      |> Enum.group_by(fn(card) -> card.suit end)
      |> Enum.flat_map(fn({ _, group}) ->
        group
          |> Poker.Hand.values()
          |> get_flush([])
      end)
  end

  def get_straight(hand) do
    hand
      |> Poker.Hand.values()
      |> get_straight([])
  end

  def get_3_kind(hand) do
    hand
      |> Poker.Hand.values()
      |> get_3_kind([])
  end

  def get_2_pair(hand) do
    hand
      |> get_pair()
      |> get_2_pair([])
      
  end

  def get_pair(hand) do
    hand
      |> Poker.Hand.values()
      |> get_pair([])
  end

  defp get_pair([ v, v | tail ], acc), do: get_pair(tail, [ { :pair, v } | acc ])
  defp get_pair([ _ | tail], acc),do: get_pair(tail, acc)
  defp get_pair([], acc), do: acc

  defp get_2_pair([{ pair, v1}, { pair, v2 } | tail], acc), do: get_2_pair(tail, [ {:pair2, max(v1, v2) } | acc ])
  defp get_2_pair([ _ | tail ], acc), do: get_2_pair(tail, acc)
  defp get_2_pair([], acc), do: acc

  defp get_3_kind([ v, v, v | tail ], acc), do: get_3_kind(tail, [ { :kind3, v } | acc ])
  defp get_3_kind([ _ | tail], acc), do: get_3_kind(tail, acc)
  defp get_3_kind([], acc), do: acc

  defp get_4_kind([ v, v, v, v | tail ], acc), do: get_4_kind(tail, [ { :kind4, v } | acc ])
  defp get_4_kind([ _ | tail], acc), do: get_4_kind(tail, acc)
  defp get_4_kind([], acc), do: acc

  defp get_flush([ v1,v2,v3,v4,v5 | tail ], acc), do: get_flush(tail, [{:flush, Enum.max([v1, v2, v3, v4, v5 ])} | acc])
  defp get_flush([ _ | tail ], acc), do: get_flush(tail, acc)
  defp get_flush([], acc), do: acc

  defp get_straight([v5, v4, v3, v2, v1 | tail ], acc) when v2 == v1+1 and v3 == v2+1 and v4 == v3+1 and v5 ==v4+1 do
    get_straight(tail, [ {:straight, v5 } | acc ])
  end
  defp get_straight([ _ | tail], acc), do: get_straight(tail, acc)
  defp get_straight([], acc), do: acc

end
