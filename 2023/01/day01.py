import sys

def get_input(file):
    return [line.strip() for line in file]

def part1(puzzle_input):
    return sum([firstlast(line) for line in puzzle_input])

def part2(puzzle_input):
    parsed = [
        line.replace('one', 'o1e')\
            .replace('two', 't2o')\
            .replace('three', 't3e')\
            .replace('four', 'f4r')\
            .replace('five', 'f5e')\
            .replace('six', 's6x')\
            .replace('seven', 's7n')\
            .replace('eight', 'e8t')\
            .replace('nine', 'n9n')
        for line in puzzle_input]

    return sum([firstlast(line) for line in parsed])

def firstlast(line):
    digits = [int(c) for c in line if c.isnumeric()]
    return digits[0] * 10 + digits[-1] if len(digits) > 0 else 0
