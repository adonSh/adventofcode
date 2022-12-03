local days = {
  require('1/sonar'),
  require('2/dive'),
  require('3/binary'),
  require('4/squid'),
  require('5/hydrothermal'),
  require('6/lanternfish'),
  require('7/whales'),
  require('8/segment'),
}

local main = function()
  local d = tonumber(arg[1])
  if d == nil then
    io.stderr:write('Specify which day to run: ')
    os.exit(1)
  end

  local input = days[d].get_input()
  print(days[d].p1(input))
  print(days[d].p2(input))
end

main()
