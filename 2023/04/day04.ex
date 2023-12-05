defmodule Day04 do
  def get_input(file) do
    for line <- IO.stream(file, :line) do
      line
      |> String.trim()
      |> String.split(":")
      |> List.last()
      |> String.split("|")
      |> Enum.map(fn ns -> ns
                           |> String.split(" ", trim: true)
                           |> Enum.map(fn n -> String.to_integer(n) end) end)
    end
  end

  def part1(cards) do
    for [winners, nums] <- cards do
      case Enum.count(nums, fn n -> n in winners end) do
        0 -> 0
        n -> 2 ** (n - 1)
      end
    end
    |> Enum.sum()
  end

  def part2(cards) do
    for {[winners, nums], i} <- Enum.with_index(cards, 1) do
      {i, Enum.count(nums, fn n -> n in winners end)}
    end
    |> count_copies(for i <- 1..length(cards), into: %{}, do: {i, 1})
    |> Map.values()
    |> Enum.sum()
  end

  defp count_copies([], copies), do: copies
  defp count_copies([{_, 0} | cards], copies), do: count_copies(cards, copies)
  defp count_copies([{c, wins} | cards], copies) do
    count_copies([{c, wins - 1} | cards],
                 %{copies | c + wins => copies[c + wins] + copies[c]})
  end
end
