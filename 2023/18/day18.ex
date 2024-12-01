defmodule Day18 do
  def get_input(file) do
    for line <- IO.stream(file, :line) do
      [dir, n, color] =
        line
        |> String.trim()
        |> String.split()
      {dir, String.to_integer(n), String.slice(color, 1..-2)}
    end
  end

  def part1(input) do
    input
    |> dig({0, 0})
    |> fill()
    |> draw()
#   |> Enum.find(fn {r, _} -> r == 0 end)
#   |> area()
#   |> Kernel.+(Enum.count(dig(input, {0, 0})))
#   |> Enum.map(fn {_, range} -> Enum.count(range) end)
#   |> Enum.sum()
  end

  def part2(_) do
    0
  end

  defp draw(trench) do
    for {_, cols} <- trench do
      for i <- 0..Enum.max(cols) do
        cond do
          i in cols -> "#"
          true -> "."
        end
        |> IO.write()
      end
      IO.write("\n")
    end
  end

  defp area(trench) do
    s1 =
      trench
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [{_, x1}, {y2, _}] -> x1 * y2 end)
      |> Enum.sum()
    s2 =
      trench
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [{y1, _}, {_, x2}] -> y1 * x2 end)
      |> Enum.sum()
    div(abs(s1 - s2), 2)
  end

  defp fill(trench) do
    {top, _} = Enum.min(trench, fn ({r1, _}, {r2, _}) -> r1 < r2 end)
    {bottom, _} = Enum.max(trench, fn ({r1, _}, {r2, _}) -> r1 > r2 end)

    for row <- top..bottom do
      cubes = for {r, c} <- trench, r == row do c end
      {row, Enum.sort(cubes)}
#     {row, Enum.min(cubes)..Enum.max(cubes)}
    end
  end

  defp dig([], _), do: []
  defp dig([{_, 0, _} | plan], {row, col}), do: dig(plan, {row, col})
  defp dig([{"U", n, color} | plan], {row, col}) do
    [{row, col} | dig([{"U", n - 1, color} | plan], {row - 1, col})]
  end
  defp dig([{"D", n, color} | plan], {row, col}) do
    [{row, col} | dig([{"D", n - 1, color} | plan], {row + 1, col})]
  end
  defp dig([{"L", n, color} | plan], {row, col}) do
    [{row, col} | dig([{"L", n - 1, color} | plan], {row, col - 1})]
  end
  defp dig([{"R", n, color} | plan], {row, col}) do
    [{row, col} | dig([{"R", n - 1, color} | plan], {row, col + 1})]
  end
end
