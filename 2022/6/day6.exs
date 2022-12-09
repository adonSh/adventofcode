defmodule Day6 do
  def main() do
    buf = IO.read(:line) |> String.trim() |> String.to_charlist()

    buf |> find_marker(4) |> IO.puts()
    buf |> find_marker(14) |> IO.puts()
  end

  defp find_marker(buf, len), do: find_marker(buf, len, 0)
  defp find_marker([first|rest], len, pos) do
    marker = Enum.take([first|rest], len)
    if length(marker) == MapSet.size(MapSet.new(marker)) do
      pos + len
    else
      find_marker(rest, len, pos + 1)
    end
  end
end

Day6.main()
