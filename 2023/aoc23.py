import sys

days = {
    1: __import__('01'),
    2: __import__('02'),
#   3: __import__('03'),
#   4: __import__('04'),
#   5: __import__('05'),
#   6: __import__('06'),
#   7: __import__('07'),
#   8: __import__('08'),
#   9: __import__('09'),
#   10: __import__('10'),
#   11: __import__('11'),
#   12: __import__('12'),
#   13: __import__('13'),
#   14: __import__('14'),
#   15: __import__('15'),
#   16: __import__('16'),
#   17: __import__('17'),
#   18: __import__('18'),
#   19: __import__('19'),
#   20: __import__('20'),
#   21: __import__('21'),
#   22: __import__('22'),
#   23: __import__('23'),
#   24: __import__('24'),
#   25: __import__('25'),
}

def solve(day, file=sys.stdin):
    puzzle_input = day.get_input(file)
    print(day.part1(puzzle_input))
    print(day.part2(puzzle_input))

while True:
    if len(sys.argv) > 1:
        d = int(sys.argv[1])
        solve(days[d])
        break
    try:
        d = int(input('Day? '))
        with open(f'{d:02}/input.txt') as f:
            solve(days[d], file=f)
    except KeyboardInterrupt:
        break
    except Exception as e:
        sys.exit(f'Error: {e}')
