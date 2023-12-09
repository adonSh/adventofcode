defmodule Day09 do
  def get_input(file) do
    for line <- IO.stream(file, :line) do
      line
      |> String.trim()
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
    end
  end

  def part1(input) do
    Enum.sum(for sequence <- input, do: gettozero(sequence))
  end

  def part2(input) do
    Enum.sum(for sequence <- input, do: gettozero(sequence, 2))
  end

  defp gettozero(steps, part \\ 1) do
    if Enum.all?(steps, fn s -> s == 0 end) do
      0
    else
      case part do
        1 -> List.last(steps) + gettozero(step_size(steps), part)
        2 -> List.first(steps) - gettozero(step_size(steps), part)
      end
    end
  end

  defp step_size([]), do: []
  defp step_size([_]), do: []
  defp step_size([a | [b | ns]]) do
    [b - a | step_size([b | ns])]
  end
end
