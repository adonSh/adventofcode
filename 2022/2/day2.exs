defmodule Day2 do
  def score("A", "X"), do: 3 + 1
  def score("A", "Y"), do: 6 + 2
  def score("A", "Z"), do: 0 + 3
  def score("B", "X"), do: 0 + 1
  def score("B", "Y"), do: 3 + 2
  def score("B", "Z"), do: 6 + 3
  def score("C", "X"), do: 6 + 1
  def score("C", "Y"), do: 0 + 2
  def score("C", "Z"), do: 3 + 3

  def calculate_move("A", "X"), do: "Z"
  def calculate_move("A", "Y"), do: "X"
  def calculate_move("A", "Z"), do: "Y"
  def calculate_move("B", "X"), do: "X"
  def calculate_move("B", "Y"), do: "Y"
  def calculate_move("B", "Z"), do: "Z"
  def calculate_move("C", "X"), do: "Y"
  def calculate_move("C", "Y"), do: "Z"
  def calculate_move("C", "Z"), do: "X"
end

rounds =
  IO.read(:stdio, :eof)
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split/1)

Enum.map(rounds, fn [a, b] -> Day2.score(a, b) end)
|> Enum.sum()
|> IO.puts()

Enum.map(rounds, fn [a, b] -> Day2.score(a, Day2.calculate_move(a, b)) end)
|> Enum.sum()
|> IO.puts()
