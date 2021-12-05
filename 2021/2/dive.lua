local M = {}

local calculate_final_position = function(directions)
  local position = { x = 0, y = 0 }

  for i = 1, #directions do
    local d = directions[i][1]
    local n = directions[i][2]
    if d == 'forward' then
      position.x = position.x + n
    elseif d == 'up' then
      position.y = position.y - n
    elseif d == 'down' then
      position.y = position.y + n
    end
  end

  return position
end

local calculate_with_aim = function(directions)
  local position = { x = 0, y = 0 }
  local aim = 0

  for i = 1, #directions do
    local d = directions[i][1]
    local n = directions[i][2]
    if d == 'forward' then
      position.x = position.x + n
      position.y = position.y + (aim * n)
    elseif d == 'up' then
      aim = aim - n
    elseif d == 'down' then
      aim = aim + n
    end
  end

  return position
end

M.get_input = function()
  local directions = {}

  while true do
    local l = io.stdin:read()
    if l == nil then break end
    local d = string.gmatch(l, '%w+')
    table.insert(directions, { d(), tonumber(d()) })
  end

  return directions
end

M.p1 = function(input)
  local pos = calculate_final_position(input)
  return pos.x * pos.y
end

M.p2 = function(input)
  local pos = calculate_with_aim(input)
  return pos.x * pos.y
end

return M
