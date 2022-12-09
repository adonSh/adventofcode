defmodule Day7 do
  def main() do
    tree = parse_tree(get_input())

    tree |> p1() |> IO.puts()
    tree |> p2() |> IO.puts()
  end

  def p2(tree) do
    total     = 70000000
    needed    = 30000000
    used      = dir_size(tree, "/")
    available = total - used

    Map.keys(tree)
    |> Enum.filter(fn dir -> available + dir_size(tree, dir) >= needed end)
    |> Enum.map(fn dir -> dir_size(tree, dir) end)
    |> Enum.min()
  end

  def p1(tree) do
    Map.keys(tree)
    |> Enum.filter(fn dir -> dir_size(tree, dir) <= 100000 end)
    |> Enum.map(fn dir -> dir_size(tree, dir) end)
    |> Enum.sum()
  end

  defp dir_size(tree, dir) do
    tree[dir]
    |> Enum.map(fn f -> if is_integer(f) do f else dir_size(tree, dir <> f <> "/") end end)
    |> Enum.sum()
  end
  
  defp parse_tree(cmds), do: parse_tree(cmds, [], %{})
  defp parse_tree([], _, tree), do: tree
  defp parse_tree([{"..", _} | cmds], [_ | path], tree), do: parse_tree(cmds, path, tree)
  defp parse_tree([{c, fs} | cmds], path, tree) do
    cwd = [if c == "/" do "" else c end | path]
    key = cwd |> Enum.reverse() |> Enum.join("/") |> Kernel.<>("/")
    children =
      fs
      |> Enum.map(fn f -> String.split(f, " ") end)
      |> Enum.map(fn [a, b] -> if a == "dir" do b else String.to_integer(a) end end)

    parse_tree(cmds, cwd, Map.put(tree, key, children))
  end

  def get_input() do
    IO.read(:eof)
    |> String.trim()
    |> String.slice(4..-1)
    |> String.split("\n$ cd")
    |> Enum.map(fn cd -> String.split(cd, "\n$ ls\n") end)
    |> Enum.map(fn ls ->
                  case ls do
                    [" " <> dir, ls] -> {dir, String.split(ls, "\n")}
                    [" .."] -> {"..", []}
                  end
                end)
  end
end

Day7.main()
