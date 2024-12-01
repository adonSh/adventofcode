def get_input(file):
    return [[int(n) for n in line.split()] for line in file]

def part1(puzzle_input):
    left = sorted([pair[0] for pair in puzzle_input])
    right = sorted([pair[1] for pair in puzzle_input])

    return sum([abs(left[i] - right[i]) for i in range(len(left))])

def part2(puzzle_input):
    left = [pair[0] for pair in puzzle_input]
    right = [pair[1] for pair in puzzle_input]

    return sum([n * right.count(n) for n in left])
