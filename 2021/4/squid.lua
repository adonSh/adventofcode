local M = {}

M.get_input = function()
  local line1 = io.stdin:read()
  if line1 == nil then return end

  local ns = {}
  local ns_called = {}
  for n in string.gmatch(line1, '%d+') do
    table.insert(ns, tonumber(n))
    ns_called[tonumber(n)] = false
  end

  local bs = {}
  while true do
    local l = io.stdin:read()
    if l == nil then break end
    if #l == 0 then
      table.insert(bs, {})
    else
      local row = {}
      for n in string.gmatch(l, '%d+') do
        table.insert(row, tonumber(n))
      end
      table.insert(bs[#bs], row)
    end
  end

  return { numbers = ns, called = ns_called, boards = bs }
end

local print_boards = function(bingo)
  for _, b in ipairs(bingo.boards) do
    for _, row in ipairs(b) do
      for _, n in ipairs(row) do
        if bingo.called[n] then io.write ('X') else io.write(n) end
        io.write(' ')
      end
      print()
    end
    print()
  end
end

local print_board = function(board)
  for _, row in ipairs(board) do
    for _, n in ipairs(row) do
      io.write(n)
      io.write(' ')
    end
    print()
  end
end

local winner = function(bingo)
  for _, b in ipairs(bingo.boards) do
    for _, row in ipairs(b) do
      local all_called = true
      for _, n in ipairs(row) do
        all_called = all_called and bingo.called[n]
      end
      if all_called then return b end
    end

    for col = 1, #b[1] do
      local all_called = true
      for _, row in ipairs(b) do
        all_called = all_called and bingo.called[row[col]]
      end
      if all_called then return b end
    end
  end

  return nil
end

local score = function(bingo, board, last_n)
  local s = 0

  for _, row in ipairs(board) do
    for _, n in ipairs(row) do
      if not bingo.called[n] then
        s = s + n
      end
    end
  end

  return s * last_n
end

local last_winner = function(bingo)
  local winners_in_order = {}

  for i, n in ipairs(bingo.numbers) do
    bingo.called[n] = true
  end
end

M.p1 = function(bingo)
  local w = nil
  local wn = 0

  for n, _ in pairs(bingo.called) do
    bingo.called[n] = false
  end

  for i, n in ipairs(bingo.numbers) do
    bingo.called[n] = true
    w = winner(bingo)
    if w ~= nil then
      wn = n
      break
    end
  end

  return score(bingo, w, wn)
end

local is_a_win = function(called, board)
  for _, row in ipairs(board) do
    local all_called = true
    for _, n in ipairs(row) do
      all_called = all_called and called[n]
    end
    if all_called then return true end
  end

  for col = 1, #board[1] do
    local all_called = true
    for _, row in ipairs(board) do
      all_called = all_called and called[row[col]]
    end
    if all_called then return true end
  end

  return false
end

local moves_to_win = function(ns, board)
  local moves = 0
  local called = {}

  for _, n in ipairs(ns) do
    called[n] = false
  end

  for _, n in ipairs(ns) do
    called[n] = true
    moves = moves + 1
    if is_a_win(called, board) then
      return moves
    end
  end

  return 0
end

M.p2 = function(bingo)
  for n, _ in pairs(bingo.called) do
    bingo.called[n] = false
  end

  local moves = {}
  for _, b in ipairs(bingo.boards) do
    table.insert(moves, moves_to_win(bingo.numbers, b))
  end

  local max = math.max(table.unpack(moves))
  for i, n in ipairs(bingo.numbers) do
    bingo.called[n] = true
    if i == max then break end
  end

  for i, n in ipairs(moves) do
    if n == max then
      return score(bingo, bingo.boards[i], bingo.numbers[n])
    end
  end

  return 0
end

return M
