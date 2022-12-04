defmodule Day4 do
  def overlaps_fully([[a,b],[c,d]]) do
    cond do
      a in c..d and b in c..d -> true
      c in a..b and d in a..b -> true
      true -> false
    end
  end

  def overlaps_partially([[a,b],[c,d]]) do
    MapSet.intersection(MapSet.new(a..b), MapSet.new(c..d))
    |> MapSet.to_list()
    |> length()
    |> Kernel.>(0)
  end
end

pairs =
  IO.read(:stdio, :eof)
  |> String.split("\n", trim: true)
  |> Enum.map(fn pair -> String.split(pair, ",") end)
  |> Enum.map(fn pair -> Enum.map(pair, fn p -> String.split(p, "-") end) end)
  |> Enum.map(fn pair -> Enum.map(pair, fn p -> Enum.map(p, &String.to_integer/1) end) end)

pairs |> Enum.filter(&Day4.overlaps_fully/1) |> length() |> IO.puts()
pairs |> Enum.filter(&Day4.overlaps_partially/1) |> length() |> IO.puts()
