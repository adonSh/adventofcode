defmodule Day05 do
  def get_input(file) do
    for line <- IO.stream(file, :line) do String.trim(line) end
    |> parse(nil, %{})
  end

  def part1(maps) do
    maps["seeds"]
    |> List.first()
    |> locate(maps, order(maps, ["seed-to-soil map"]))
    |> Enum.min()
  end

  def part2(maps) do
    maps["seeds"]
    |> List.first()
    |> Enum.chunk_every(2)
    |> Enum.map(fn [start, len] -> start..start+len-1 end)
    |> locate_all(maps, order(maps, ["seed-to-soil map"]))
    |> Enum.min()
  end

  defp locate_all(ranges, maps, steps) do
    pid = self()
    for r <- ranges, do: spawn(fn () -> locate2(r, maps, steps, pid) end)
    locate_all(ranges, maps, steps, length(ranges), [])
  end
  defp locate_all(_, _, _, 0, mins), do: mins
  defp locate_all(ranges, maps, steps, waiting, mins) do
    receive do
      m -> locate_all(ranges, maps, steps, waiting - 1, [m | mins])
    end
  end

  defp locate2(seeds, _, [], parent), do: send(parent, Enum.min(seeds))
  defp locate2(seeds, maps, [step | next], parent) do
    for s <- seeds do compute(maps[step], s) end
    |> locate2(maps, next, parent)
  end

  defp locate(seeds, _, []), do: seeds
  defp locate(seeds, maps, [step | next]) do
    for s <- seeds do compute(maps[step], s) end
    |> locate(maps, next)
  end

  defp compute(map, n) do
    case Enum.find(map, fn [_, s, r] -> s <= n and n < s + r end) do
      nil -> n
      [d, s, _] -> d + (n - s)
    end
  end

  defp order(maps, [first | rest]) do
    case String.split(first, " ") |> List.first() |> String.split("-") |> List.last() do
      "location" -> Enum.reverse([first | rest])
      next -> order(maps, [find_map(maps, next) | [first | rest]])
    end
  end

  defp find_map(maps, name) do
    key =
      Map.keys(maps)
      |> Enum.find(fn k -> String.contains?(k, "#{name}-to") end)
    key
  end

  defp parse([], _, map), do: map
  defp parse([line | rest], nil, map) do
    case String.split(line, ":") do
      [key, ""] -> parse(rest, key, map)
      [key, more] -> parse([more | rest], key, map)
      _ -> parse(rest, nil, map)
    end
  end
  defp parse([line | rest], key, map) do
    parse(rest, nil, Map.put(map, key, parse_vals([line | rest])))
  end

  defp parse_vals([]), do: []
  defp parse_vals(["" | _]), do: []
  defp parse_vals([s | ss]) do
    [for n <- String.split(s, " ", trim: true) do String.to_integer(n) end | parse_vals(ss)]
  end
end
