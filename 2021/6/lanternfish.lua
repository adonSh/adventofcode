local M = {}

M.get_input = function()
  local ns = {}

  for n in string.gmatch(io.read(), '%d+') do
    table.insert(ns, tonumber(n))
  end

  return ns
end

local naive_sim = function(fish)
  local new = {}

  for _, f in ipairs(fish) do
    if f > 0 then
      table.insert(new, f - 1)
    else
      table.insert(new, 6)
      table.insert(new, 8)
    end
  end

  return new
end

M.p1 = function(fish)
  local fish_next = naive_sim(fish)

  for i = 2, 80 do
    fish_next = naive_sim(fish_next)
  end

  return #fish_next
end

local sim = function(fish)
  local moms = fish[0]
  
  for i = 0, #fish - 1 do
    fish[i] = fish[i + 1]
  end

  fish[6] = fish[6] + moms
  fish[8] = moms
end

M.p2 = function(fish)
  local counts = {}
  for i = 0, 8 do counts[i] = 0 end
  for _, f in ipairs(fish) do
    counts[f] = counts[f] + 1
  end

  for i = 1, 256 do
    sim(counts)
  end

  local total = 0
  for _, n in pairs(counts) do
    total = total + n
  end

  return total
end

return M
