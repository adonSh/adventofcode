local M = {}

local count_increases = function(ns)
  local num = 0
  
  for i = 1, #ns - 1 do
    if ns[i + 1] > ns[i] then
      num = num + 1
    end
  end

  return num
end

local count_windows = function(ns)
  local num = 0

  for i = 1, #ns - 3 do
    local n1 = ns[i] + ns[i+1] + ns[i+2]
    local n2 = ns[i+1] + ns[i+2] + ns[i+3]
    if n2 > n1 then
      num = num + 1
    end
  end

  return num
end

M.get_input = function()
  local ns = {}

  while true do
    local l = io.stdin:read()
    if l == nil then break end
    table.insert(ns, tonumber(l))
  end

  return ns
end

M.p1 = function(input)
  return count_increases(input)
end

M.p2 = function(input)
  return count_windows(input)
end

return M
