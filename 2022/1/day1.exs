defmodule Day1 do
  def p1(ns) do
    ns |> Enum.map(&Enum.sum/1) |> Enum.max()
  end

  def p2(ns) do
    Enum.map(ns, &Enum.sum/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end
end

ns =
  IO.read(:stdio, :eof)
  |> String.split("\n\n")
  |> Enum.map(fn grp -> String.split(grp, "\n", trim: true) end)
  |> Enum.map(fn grp -> Enum.map(grp, &String.to_integer/1) end)

ns |> Day1.p1() |> IO.puts()
ns |> Day1.p2() |> IO.puts()
