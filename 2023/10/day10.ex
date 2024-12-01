defmodule Day10 do
  def get_input(file) do
    for line <- IO.stream(file, :line) do
      line
      |> String.trim()
      |> String.graphemes()
    end
  end

  def part1(input) do
    input |> IO.inspect()
    |> find_start()
  end

  def part2(_) do
    0
  end

  defp find_start(map) do
    for {line, row} <- Enum.with_index(map), "S" in line do
      {"S", col} =
        line
        |> Enum.with_index()
        |> Enum.find(fn {s, _} -> s == "S" end)
      {row, col}
    end
    |> List.first()
  end
end
