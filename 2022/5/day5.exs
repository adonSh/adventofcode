defmodule Day5 do
  def main() do
    {stacks, moves} = get_input()

    IO.puts(p1(stacks, moves))
    IO.puts(p2(stacks, moves))
  end

  def p2(stacks, []), do: List.to_string(for {_, [top | _]} <- stacks, do: top)
  def p2(stacks, [[num, from, to] | moves]) do
    %{stacks | to   => Enum.take(stacks[from], num) ++ stacks[to],
               from => Enum.slice(stacks[from], num..-1)}
    |> p2(moves)
  end

  def p1(stacks, []), do: List.to_string(for {_, [top | _]} <- stacks, do: top)
  def p1(stacks, [[0, _, _] | moves]), do: p1(stacks, moves)
  def p1(stacks, [[num, from, to] | moves]) do
    %{stacks | to   => [hd(stacks[from]) | stacks[to]],
               from => tl(stacks[from])}
    |> p1([[num - 1, from, to] | moves])
  end

  defp parse_stacks(crates) do
    rows = Enum.map(String.split(crates, "\n"), &String.to_charlist/1)
    labels = List.last(rows)
    positions =
      0..length(labels)
      |> Enum.filter(fn i -> Enum.at(labels, i) in ?0..?9 end)
      |> Enum.map(fn i -> {i, Enum.at(labels, i) - ?0} end)
      |> Map.new()

    for {i, stack} <- positions, into: %{} do
      {stack, for r <- rows, Enum.at(r, i) in ?A..?Z do Enum.at(r, i) end}
    end
  end

  def get_input() do
    [crates, procedure] = String.split(IO.read(:eof), "\n\n")
    moves =
      procedure
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn p -> String.split(p, " ") end)
      |> Enum.map(fn ws -> for w <- ws, Integer.parse(w) != :error, do: w end)
      |> Enum.map(fn ws -> Enum.map(ws, &String.to_integer/1) end)

    {parse_stacks(crates), moves}
  end
end

Day5.main()
