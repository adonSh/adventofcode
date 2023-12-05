defmodule Day03 do
  def get_input(file) do
    for line <- IO.stream(file, :line), do: String.trim(line)
  end

  def part1(input) do
    sym_map = map_symbols(input)
    num_map = map_numbers(input)
    for {n, cs} <- num_map, Enum.any?(cs, fn c -> Enum.any?(sym_map, fn s -> adjacent?(c, s) end) end) do
      n
    end
    |> Enum.sum()
  end

  def part2(input) do
    num_map = map_numbers(input)
    gear_map = input
      |> map_symbols()
      |> Enum.filter(fn {y, x} -> Enum.at(input, y)
                                  |> String.to_charlist()
                                  |> Enum.at(x) == ?*
                                  and count_adjacents({y, x}, num_map) == 2 end)
    for g <- gear_map do
      for {n, cs} <- num_map, Enum.any?(cs, fn c -> adjacent?(c, g) end) do
        n
      end
      |> Enum.product()
    end
    |> Enum.sum()
  end

  defp count_adjacents(sym, nums) do
    Enum.count(nums, fn {_, cs} -> Enum.any?(cs, fn c -> adjacent?(c, sym) end) end)
  end

  defp map_symbols(input) do
    for {line, row} <- Enum.with_index(input) do
      for {c, col} <- String.to_charlist(line) |> Enum.with_index(),
          c != ?.,
          c < ?0 or c > ?9 do
        {row, col}
      end
    end
    |> List.flatten()
  end

  defp map_numbers(input) do
    for {line, row} <- Enum.with_index(input) do
      for {c, col} <- String.to_charlist(line) |> Enum.with_index(),
          ?0 <= c and c <= ?9 do
        {c - ?0, {row, col}}
      end
    end
    |> Enum.map(fn row -> collect_nums(row, [], []) |> Enum.zip() end)
    |> List.flatten()
  end

  defp collect_nums([], nums, coords) do
    [
      for n <- nums do Enum.reverse(n) |> Enum.join() |> String.to_integer() end
      |> Enum.reverse(),
      Enum.map(coords, &Enum.reverse/1) |> Enum.reverse(),
    ]
  end
  defp collect_nums([{d, c} | ds], [], []), do: collect_nums(ds, [[d]], [[c]])
  defp collect_nums([{d, {y, x}} | ds], [n | ns], [[{yy, xx} | c] | cs]) do
    case x - xx do
      1 ->
        collect_nums(ds, [[d | n] | ns], [[{y, x} | [{yy, xx} | c]] | cs])
      _ ->
        collect_nums(ds, [[d] | [n | ns]], [[{y, x}] | [[{yy, xx} | c] | cs]])
    end
  end

  defp adjacent?({y1, x1}, {y2, x2}) do
    abs(y2 - y1) < 2 and abs(x2 - x1) < 2
  end
end
