defmodule Day16 do
  def get_input(file) do
    for line <- IO.stream(file, :line) do
      line
      |> String.trim()
      |> String.graphemes()
    end
  end

  def part1(input) do
    input
    |> energize({0, 0}, :east)
  end

  def part2(_) do
    0
  end

  defp energize(layout, {row, col}, :south) do
    case layout |> Enum.at(row) |> Enum.at(col) do
      "/"  -> [{row, col} | energize(layout, {row, col - 1}, :west)]
      "\\" -> [{row, col} | energize(layout, {row, col + 1}, :east)]
      "-"  -> [{row, col} | energize(layout, {row, col + 1}, :east) ++ energize(layout, {row, col - 1}, :west)]
      _  -> [{row, col} | energize(layout, {row, col + 1}, :east)]
    end
  end
  defp energize(layout, {row, col}, :east) do
    case layout |> Enum.at(row) |> Enum.at(col) do
      "/"  -> [{row, col} | energize(layout, {row - 1, col}, :north)]
      "\\" -> [{row, col} | energize(layout, {row + 1, col}, :south)]
      "|"  -> [{row, col} | energize(layout, {row - 1, col}, :north) ++ energize(layout, {row + 1, col}, :south)]
      _  -> [{row, col} | energize(layout, {row, col + 1}, :east)]
    end
  end
end
