defmodule Day06 do
  def get_input(file) do
    for line <- IO.stream(file, :line) do
      line
      |> String.trim()
      |> String.split(" ", trim: true)
      |> tl()
      |> Enum.map(&String.to_integer/1)
    end
    |> Enum.zip()
  end

  def part1(races) do
    Enum.product(for r <- races, do: ways_to_win(r))
  end

  def part2(races) do
    {t, d} = Enum.unzip(races)
    {Enum.join(t) |> String.to_integer(), Enum.join(d) |> String.to_integer()}
    |> ways_to_win()
  end

  defp ways_to_win({time, record}) do
    for speed <- 0..time do {speed, speed * (time - speed)} end
    |> Enum.count(fn {_, distance} -> distance > record end)
  end
end
