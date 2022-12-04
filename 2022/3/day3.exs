defmodule Day3 do
  def priority(a) when hd(a) >= ?a, do: hd(a) - 96
  def priority(a) when hd(a) <= ?Z, do: hd(a) - 38

  def p1(sacks) do
    Enum.map(sacks, fn {a, b} ->
      find_common([String.to_charlist(a), String.to_charlist(b)])
    end)
    |> Enum.map(&priority/1)
    |> Enum.sum()
  end

  def p2(sacks) do
    Enum.map(sacks, fn s ->
      Enum.map(s, &String.to_charlist/1) |> find_common()
    end)
    |> Enum.map(&priority/1)
    |> Enum.sum()
  end

  defp find_common(sacks), do: find_common_rec(sacks) |> MapSet.to_list()

  defp find_common_rec([last]), do: MapSet.new(last)
  defp find_common_rec([first|rest]) do
    MapSet.intersection(find_common_rec(rest), MapSet.new(first))
  end
end

lines = IO.read(:stdio, :eof) |> String.split("\n", trim: true)
sacks = Enum.map(lines, fn l ->
  String.split_at(l, div(String.length(l), 2))
end)

sacks |> Day3.p1() |> IO.puts()
lines |> Enum.chunk_every(3) |> Day3.p2() |> IO.puts()
