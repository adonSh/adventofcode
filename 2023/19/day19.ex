defmodule Day19 do
  def get_input(file) do
    [workflows, _] =
      file
      |> IO.read(:eof)
      |> String.trim()
      |> String.split("\n\n")
      |> Enum.map(&String.split(&1, "\n"))
    for w <- workflows, do: parse(w)
  end

  def part1(input) do
    input
  end

  def part2(_) do
    0
  end

  defp parse(raw) do
    [_, wf] = String.split(raw, "{")
    {ws, auto} =
      wf
      |> String.slice(0..-2)
      |> String.split(",")
      |> Enum.split(-1)
    for w <- ws do
      [f, l] = String.split(w, ":")
      {String.at(f, 0), String.at(f, 1), String.slice(f, 2..-1), l}
    end
    ++ auto
  end
end
