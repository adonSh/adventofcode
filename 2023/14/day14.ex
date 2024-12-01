defmodule Day14 do
  def get_input(file) do
    for line <- IO.stream(file, :line) do
      line
      |> String.trim()
      |> String.graphemes()
    end
  end

  def part1(input) do
    input
    |> find_rocks()
    |> tilt(input, :north)
    |> find_rocks()
    |> calculate_load(length(input))
  end

  def part2(input) do
    {map, period, remainder} = find_period(input)
    cycle(map, rem(1000000000 - remainder, period))
    |> find_rocks()
    |> calculate_load(length(input))
  end

  defp find_period(map), do: find_period(map, [])
  defp find_period(map, seen) do
    case Enum.find_index(seen, fn m -> m == map end) do
      nil -> find_period(cycle(map, 1), [map | seen])
      n -> {map, n + 1, length(seen)}
    end
  end

  defp cycle(map, 0), do: map
  defp cycle(map, n) do
    rocks = find_rocks(map)
    map1 = tilt(rocks, map, :north)
    rocks1 = find_rocks(map1)
    map2 = tilt(rocks1, map1, :west)
    rocks2 = find_rocks(map2) |> Enum.reverse()
    map3 = tilt(rocks2, map2, :south)
    rocks3 = find_rocks(map3) |> Enum.reverse()
    tilt(rocks3, map3, :east)
    |> cycle(n - 1)
  end

  defp calculate_load([], _), do: 0
  defp calculate_load([{row, _} | rocks], height) do
    height - row + calculate_load(rocks, height)
  end

  defp find_rocks(map) do
    for {line, row} <- Enum.with_index(map) do
      for {ch, col} <- Enum.with_index(line), ch == "O" do
        {row, col}
      end
    end
    |> List.flatten()
  end

  defp tilt([], map, _), do: map
  defp tilt([{row, col} | rocks], map, dir) do
    {nrow, ncol} = slide({row, col}, map, dir)
    oldrow = List.replace_at(Enum.at(map, row), col, ".")
    newrow =
      case dir do
        :north -> List.replace_at(Enum.at(map, nrow), ncol, "O")
        :south -> List.replace_at(Enum.at(map, nrow), ncol, "O")
        :east  -> List.replace_at(oldrow, ncol, "O")
        :west  -> List.replace_at(oldrow, ncol, "O")
      end
    newmap = List.replace_at(map, row, oldrow) |> List.replace_at(nrow, newrow)
    tilt(rocks, newmap, dir)
  end

  defp slide({row, col}, map, :east) when col + 1 == length(hd(map)), do: {row, col}
  defp slide({row, col}, map, :east) when col + 1 != length(hd(map)) do
    case map |> Enum.at(row) |> Enum.at(col + 1) do
      "#" -> {row, col}
      "O" -> {row, col}
      _   -> slide({row, col + 1}, map, :east)
    end
  end
  defp slide({row, 0}, _, :west), do: {row, 0}
  defp slide({row, col}, map, :west) do
    case map |> Enum.at(row) |> Enum.at(col - 1) do
      "#" -> {row, col}
      "O" -> {row, col}
      _   -> slide({row, col - 1}, map, :west)
    end
  end
  defp slide({row, col}, map, :south) when row + 1 == length(map), do: {row, col}
  defp slide({row, col}, map, :south) when row + 1 != length(map) do
    case map |> Enum.at(row + 1) |> Enum.at(col) do
      "#" -> {row, col}
      "O" -> {row, col}
      _   -> slide({row + 1, col}, map, :south)
    end
  end
  defp slide({0, col}, _, :north), do: {0, col}
  defp slide({row, col}, map, :north) do
    case map |> Enum.at(row - 1) |> Enum.at(col) do
      "#" -> {row, col}
      "O" -> {row, col}
      _   -> slide({row - 1, col}, map, :north)
    end
  end
end
