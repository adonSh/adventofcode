local M = {}

M.get_input = function()
  local lines = {}

  while true do
    local l = io.read()
    if l == nil then break end
    local ps = string.gmatch(l, '%d+')
    table.insert(lines, { a = { x = tonumber(ps()), y = tonumber(ps()) }, b = { x = tonumber(ps()), y = tonumber(ps()) } })
  end

  return lines
end

local filter_str8s = function(lines)
  local str8s = {}

  for _, l in ipairs(lines) do
    if l.a.x == l.b.x or l.a.y == l.b.y then
      table.insert(str8s, l)
    end
  end

  return str8s
end

local count = function(lines)
  local counts = {}

  for _, l in ipairs(lines) do
    if l.a.x == l.b.x then
      local x = l.a.x
      if counts[x] == nil then counts[x] = {} end
      if l.b.y > l.a.y then
        for y = l.a.y, l.b.y do
          if counts[x][y] == nil then counts[x][y] = 0 end
          counts[x][y] = counts[x][y] + 1
        end
      else
        for y = l.a.y, l.b.y, -1 do
          if counts[x][y] == nil then counts[x][y] = 0 end
          counts[x][y] = counts[x][y] + 1
        end
      end
    elseif l.a.y == l.b.y then
      local y = l.a.y
      if l.b.x > l.a.x then
        for x = l.a.x, l.b.x do
          if counts[x] == nil then counts[x] = {} end
          if counts[x][y] == nil then counts[x][y] = 0 end
          counts[x][y] = counts[x][y] + 1
        end
      else
        for x = l.a.x, l.b.x, -1 do
          if counts[x] == nil then counts[x] = {} end
          if counts[x][y] == nil then counts[x][y] = 0 end
          counts[x][y] = counts[x][y] + 1
        end
      end
    else
      local y = l.a.y
      if l.b.x > l.a.x then
        for x = l.a.x, l.b.x do
          if counts[x] == nil then counts[x] = {} end
          if counts[x][y] == nil then counts[x][y] = 0 end
          counts[x][y] = counts[x][y] + 1
          if l.b.y > l.a.y then
            y = y + 1
          else
            y = y - 1
          end
        end
      else
        for x = l.a.x, l.b.x, -1 do
          if counts[x] == nil then counts[x] = {} end
          if counts[x][y] == nil then counts[x][y] = 0 end
          counts[x][y] = counts[x][y] + 1
          if l.b.y > l.a.y then
            y = y + 1
          else
            y = y - 1
          end
        end
      end
    end
  end

  return counts
end

M.p1 = function(lines)
  local straights = filter_str8s(lines)
  local counts = count(straights)
  local xs = 0

  for x, row in pairs(counts) do
    for y, col in pairs(row) do
      if col > 1 then
        xs = xs + 1
      end
    end
  end

  return xs
end

M.p2 = function(lines)
  local counts = count(lines)
  local xs = 0

  for x, row in pairs(counts) do
    for y, val in pairs(row) do
      if val > 1 then
        xs = xs + 1
      end
    end
  end

  return xs
end

return M
