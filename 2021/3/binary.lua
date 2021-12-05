local binary_to_string = function(n)
  local s = ''

  for i = 1, #n do
    s = s .. tostring(n[i])
  end

  return s
end

local most_common = function(ns)
  local counts = {}
 
  for i = 1, #ns do
    if counts[ns[i]] == nil then
      counts[ns[i]] = 1
    else
      counts[ns[i]] = counts[ns[i]] + 1
    end
  end

  local max = 0
  local mc = nil
  for k, v in pairs(counts) do
    if v > max then
      max = v
      mc = k
    end
  end

  return mc
end

local gamma = function(ns)
  local g = {}

  for i = 1, #ns[1] do
    local bits = {}
    for j = 1, #ns do
      table.insert(bits, ns[j][i])
    end
    table.insert(g, most_common(bits))
  end

  return g
end

local epsilon = function(g)
  local e = {}

  for i = 1, #g do
    if g[i] == 0 then
      table.insert(e, 1)
    elseif g[i] == 1 then
      table.insert(e, 0)
    end
  end

  return e
end

local binary_to_decimal = function(b)
  local m = 1
  local d = 0

  for i = #b, 1, -1 do
    d = d + (b[i] * m)
    m = m * 2
  end

  return d
end

local count_digit = function(ns, n)
  local count = 0

  for i = 1, #ns do
    if ns[i] == n then
      count = count + 1
    end
  end

  return count
end

local o2_rating = function(ns)
  local candidates = { table.unpack(ns) }

  for i = 1, #candidates[1] do
    if #candidates == 1 then
      break
    end

    local bits = {}
    for j = 1, #candidates do
      table.insert(bits, candidates[j][i])
    end

    local ones = count_digit(bits, 1)
    local zeros = count_digit(bits, 0)
    local mc
    if zeros > ones then
      mc = 0
    else
      mc = 1
    end

    local tmp = {}
    for j = 1, #candidates do
      if candidates[j][i] == mc then
        table.insert(tmp, candidates[j])
      end
    end
    candidates = tmp
  end

  return candidates[1]
end

local co2_rating = function(ns)
  local candidates = { table.unpack(ns) }

  for i = 1, #candidates[1] do
    if #candidates == 1 then
      break
    end

    local bits = {}
    for j = 1, #candidates do
      table.insert(bits, candidates[j][i])
    end

    local ones = count_digit(bits, 1)
    local zeros = count_digit(bits, 0)
    local lc
    if ones < zeros then
      lc = 1
    else
      lc = 0
    end

    local tmp = {}
    for j = 1, #candidates do
      if candidates[j][i] == lc then
        table.insert(tmp, candidates[j])
      end
    end
    candidates = tmp
  end

  return candidates[1]
end

local main = function()
  local ns = {}

  while true do
    local l = io.stdin:read()
    if l == nil then break end
    local n = {}
    for i = 1, string.len(l) do
      table.insert(n, tonumber(string.sub(l, i, i)))
    end
    table.insert(ns, n)
  end

  local g = gamma(ns)
  local e = epsilon(g)
  local o2 = o2_rating(ns)
  local co2 = co2_rating(ns)

  print(binary_to_decimal(g) * binary_to_decimal(e))
  print(binary_to_decimal(o2) * binary_to_decimal(co2))
end

main()
