defmodule Day02 do
  def get_input(file) do
    file
    |> IO.read(:eof)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.slice(line, 5..-1) |> String.split(":") end)
    |> quantize()
  end

  def part1(input) do
    cubes = %{"red" => 12, "green" => 13, "blue" => 14}
    for {id, game} <- input, Enum.all?(game, fn r -> possible?(r, cubes) end) do
      id
    end
    |> Enum.sum()
  end

  def part2(input) do
    for {_, game} <- input do
      Enum.max(for r <- game, do: Map.get(r, "red", 0)) *
      Enum.max(for r <- game, do: Map.get(r, "green", 0)) *
      Enum.max(for r <- game, do: Map.get(r, "blue", 0))
    end
    |> Enum.sum()
  end

  defp possible?(round, counts) do
    Map.get(round, "red", 0) <= counts["red"] and
    Map.get(round, "green", 0) <= counts["green"] and
    Map.get(round, "blue", 0) <= counts["blue"]
  end

  defp quantize(games) do
    for [id, g] <- games, into: %{} do
      {
        String.to_integer(id),
        for round <- String.split(g, ";") do
          for count <- String.split(round, ","), into: %{} do
            parts = String.split(count, " ", trim: true)
            {List.last(parts), List.first(parts) |> String.to_integer()}
          end
        end
      }
    end
  end
end
