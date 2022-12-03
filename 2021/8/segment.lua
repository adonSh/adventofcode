local M = {}

M.get_input = function()
  local lines = {}
  while true do
    local l = io.read()
    if l == nil then break end
    table.insert(lines, l)
  end

  local segments = {}
  for _, l in ipairs(lines) do
    local before = string.match(l, '.+|')
    local after = string.match(l, '|.+')
    local seg = { before = {}, after = {} }
    for w in string.gmatch(before, '%a+') do
      table.insert(seg.before, w)
    end
    for w in string.gmatch(after, '%a+') do
      table.insert(seg.after, w)
    end
    table.insert(segments, seg)
  end

  return segments
end

local occurences_by_length = function(ws, w)
  local count = 0

  for i = 1, #ws do
    if #ws[i] == #w then
      count = count + 1
    end
  end

  return count
end

M.p1 = function(segments)
  local count = 0
  local digits = {}
  digits[1] = 'cf'
  digits[4] = 'bcdf'
  digits[7] = 'acf'
  digits[8] = 'abcdefg'

  for _, s in ipairs(segments) do
    count = count + occurences_by_length(s.after, digits[1])
    count = count + occurences_by_length(s.after, digits[4])
    count = count + occurences_by_length(s.after, digits[7])
    count = count + occurences_by_length(s.after, digits[8])
  end

  return count
end

local string_equals_order_naive = function(a, b)
  local a_set = {}
  local b_set = {}
  for i = 1, #a do
    a_set[string.sub(a, i, i)] = 1
  end
  for i = 1, #b do
    b_set[string.sub(b, i, i)] = 1
  end

  for k, _ in pairs(a_set) do
    if b_set[k] == nil then
      return false
    end
  end
  for k, _ in pairs(b_set) do
    if a_set[k] == nil then
      return false
    end
  end

  return true
end

local find = function(n)
  return function(words)
    for i, w in ipairs(words) do
      if #w == n then return w end
    end
    return ''
  end
end

local decode = function(segment)
  local digits = {}
  digits[1] = find(2)(segment.before)
  digits[4] = find(4)(segment.before)
  digits[7] = find(3)(segment.before)
  digits[8] = find(7)(segment.before)

  return digits
end

M.p2 = function(segments)
--print(string_equals_order_naive('abce', 'cbad'))
  print(find(2)(segments[1].before))

  return 0
end

return M
