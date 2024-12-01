defmodule Day15 do
  def get_input(file) do
    file
    |> IO.read(:eof)
    |> String.trim()
    |> String.split(",")
  end

  def part1(input) do
    input
    |> Enum.map(&hash/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> sort_lenses()
    |> Enum.reject(fn {_, l} -> Enum.empty?(l) end)
    |> Enum.map(fn {box, lenses} ->
                  lenses
                  |> Enum.with_index(1)
                  |> Enum.map(fn {{_, n}, i} ->
                                (box + 1) * i * n
                              end)
                end)
    |> List.flatten()
    |> Enum.sum()
  end

  defp sort_lenses(steps) do
    sort_lenses(steps, for i <- 0..255, into: %{} do {i, []} end)
  end
  defp sort_lenses([], boxes), do: boxes
  defp sort_lenses([s | steps], boxes) do
    cond do
      String.contains?(s, "=") ->
        [label, n] = String.split(s, "=")
        box = hash(label)
        newlist =
          case Enum.find_index(boxes[box], fn {l, _} -> l == label end) do
            nil -> boxes[box] ++ [{label, String.to_integer(n)}]
            i -> List.replace_at(boxes[box], i, {label, String.to_integer(n)})
          end
        sort_lenses(steps, Map.put(boxes, box, newlist))
      String.contains?(s, "-") ->
        label = s |> String.split("-") |> List.first()
        box = hash(label)
        newlist =
          case Enum.find_index(boxes[box], fn {l, _} -> l == label end) do
            nil -> boxes[box]
            i -> List.delete_at(boxes[box], i)
          end
        sort_lenses(steps, Map.put(boxes, box, newlist))
    end
  end

  defp hash(string), do: string |> String.to_charlist() |> hash(0)
  defp hash([], val), do: val
  defp hash([ch | chs], val), do: hash(chs, rem((val + ch) * 17, 256))
end
