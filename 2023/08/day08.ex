defmodule Day08 do
  def get_input(file) do
    [rl | ["" | nodes]] = for line <- IO.stream(file, :line), do: String.trim(line)
    {
      String.graphemes(rl),
      for n <- nodes, into: %{} do
        [label, choices] = String.split(n, " = ")
        {
          label,
          String.graphemes(choices)
          |> Enum.reject(fn c -> c == "(" or c == ")" end)
          |> Enum.join()
          |> String.split(", "),
        }
      end,
    }
  end

  def part1({instructions, nodes}) do
    find(instructions, nodes, fn n -> n == "ZZZ" end)
  end

  def part2({instructions, nodes}) do
    for {n, _} <- nodes, String.ends_with?(n, "A") do
      find(instructions, nodes, &String.ends_with?(&1, "Z"), n)
    end
    |> lcm()
  end

  defp lcm([n]), do: n
  defp lcm([a | [b | ns]]) do
    lcm([div(a * b, Integer.gcd(a, b)) | ns])
  end

  defp find(instructions, nodes, found?, cur \\ "AAA") do
    find(instructions, instructions, nodes, found?, cur, 0)
  end
  defp find([], record, nodes, found?, cur, n) do
    find(record, record, nodes, found?, cur, n)
  end
  defp find([i | instructions], record, nodes, found?, cur, n) do
    if found?.(cur) do
      n
    else
      case i do
        "R" -> find(instructions, record, nodes, found?, List.last(nodes[cur]), n + 1)
        "L" -> find(instructions, record, nodes, found?, List.first(nodes[cur]), n + 1)
      end
    end
  end
end
