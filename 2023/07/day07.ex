defmodule Day07 do
  def get_input(file) do
    for line <- IO.stream(file, :line), into: %{} do
      [hand, bid] = String.trim(line) |> String.split(" ")
      {hand, String.to_integer(bid)}
    end
  end

  def part1(hands) do
    hands
    |> Enum.map(fn {h, _} -> {h, type(h)} end)
    |> Enum.sort(&compare/2)
    |> Enum.with_index(1)
    |> Enum.map(fn {{h, _}, rank} -> hands[h] * rank end)
    |> Enum.sum()
  end

  def part2(hands) do
    hands
    |> Enum.map(fn {h, _} -> {h, process_wildcards(h) |> type()} end)
    |> Enum.sort(fn a, b -> compare(a, b, true) end)
    |> Enum.with_index(1)
    |> Enum.map(fn {{h, _}, rank} -> hands[h] * rank end)
    |> Enum.sum()
  end

  defp process_wildcards(hand) do
    {best_card, _} =
      hand
      |> String.graphemes()
      |> Enum.reject(fn g -> g == "J" end)
      |> case do [] -> List.duplicate("A", 5); gs -> gs end
      |> count(%{})
      |> Enum.max(fn {a, n1}, {b, n2} ->
                    if n1 == n2 do
                      strength(a, true) > strength(b, true)
                    else
                      n1 > n2
                    end
                  end)
    String.replace(hand, "J", best_card)
  end

  defp compare(hand1, hand2, jokers? \\ false)
  defp compare({hand1, type1}, {hand2, type2}, jokers?) when type1 == type2 do
    compare(String.graphemes(hand1), String.graphemes(hand2), jokers?)
  end
  defp compare({_, type1}, {_, type2}, jokers?) when type1 != type2 do
    strength(type1, jokers?) < strength(type2, jokers?)
  end
  defp compare([card1 | hand1], [card2 | hand2], jokers?) when card1 == card2 do
    compare(hand1, hand2, jokers?)
  end
  defp compare([card1 | _], [card2 | _], jokers?) when card1 != card2 do
    strength(card1, jokers?) < strength(card2, jokers?)
  end

  defp strength(:fiveofakind, _), do: 6
  defp strength(:fourofakind, _), do: 5
  defp strength(:fullhouse, _), do: 4
  defp strength(:threeofakind, _), do: 3
  defp strength(:twopair, _), do: 2
  defp strength(:pair, _), do: 1
  defp strength(:highcard, _), do: 0
  defp strength("A", _), do: 14
  defp strength("K", _), do: 13
  defp strength("Q", _), do: 12
  defp strength("J", false), do: 11
  defp strength("J", true), do: 0
  defp strength("T", _), do: 10
  defp strength(c, _), do: String.to_integer(c)

  defp type(hand) do
    counts = String.graphemes(hand) |> count(%{})
    case Enum.max(counts, fn {_, n1}, {_, n2} -> n1 > n2 end) do
      {_, 5} -> :fiveofakind
      {_, 4} -> :fourofakind
      {_, 3} -> if 2 in Map.values(counts) do :fullhouse else :threeofakind end
      {_, 2} -> case Enum.count(counts, fn {_, n} -> n == 2 end) do
                  2 -> :twopair
                  1 -> :pair
                end
      {_, 1} -> :highcard
    end
  end

  defp count([], counts), do: counts
  defp count([card | hand], counts) do
    count(hand, Map.put(counts, card, Map.get(counts, card, 0) + 1))
  end
end
