local M = {}

M.get_input = function()
  local ns = {}

  for n in string.gmatch(io.read(), '%d+') do
    table.insert(ns, tonumber(n))
  end

  return ns
end

M.p1 = function(crabs)
  local sorted = { table.unpack(crabs) }
  table.sort(sorted)
  local best_pos = sorted[#sorted // 2]
  local fuel = 0

  for _, n in ipairs(crabs) do
    fuel = fuel + math.abs(n - best_pos)
  end

  return fuel
end

local fuel_from = function(a, b)
  local cost = 1
  local total = 0

  if b > a then
    for i = a, b - 1 do
      total = total + cost
      cost = cost + 1
    end
  else
    for i = a, b + 1, -1 do
      total = total + cost
      cost = cost + 1
    end
  end

  return total
end

M.p2 = function(crabs)
  local sums = {}
  for i = 0, math.max(table.unpack(crabs)) do
    sums[i] = 0
    for _, n in ipairs(crabs) do
      sums[i] = sums[i] + fuel_from(n, i)
    end
  end

  return math.min(table.unpack(sums))
end

return M
