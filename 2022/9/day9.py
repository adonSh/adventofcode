from sys import stdin
from time import sleep

def adjacent(h: tuple[int, int], t: tuple[int, int]) -> bool:
    return abs(h[0] - t[0]) < 2 and abs(h[1] - t[1]) < 2

def move(rope: list[tuple[int, int]], m: tuple[str, int]) -> list[list[tuple[int, int]]]:
    if m[1] == 0:
        return []

    knots = [(0, 0) for _ in rope]
    if m[0] == 'R':
        knots[0] = (rope[0][0] + 1, rope[0][1])
    if m[0] == 'U':
        knots[0] = (rope[0][0], rope[0][1] + 1)
    if m[0] == 'L':
        knots[0] = (rope[0][0] - 1, rope[0][1])
    if m[0] == 'D':
        knots[0] = (rope[0][0], rope[0][1] - 1)

    for i in range(1, len(knots)):
        newx = rope[i][0]
        newy = rope[i][1]
        if not adjacent(knots[i-1], rope[i]):
            if knots[i-1][0] > rope[i][0]:
                newx = rope[i][0] + 1
            if knots[i-1][0] < rope[i][0]:
                newx = rope[i][0] - 1
            if knots[i-1][1] > rope[i][1]:
                newy = rope[i][1] + 1
            if knots[i-1][1] < rope[i][1]:
                newy = rope[i][1] - 1
        knots[i] = (newx, newy)

    return [knots] + move(knots, (m[0], m[1] - 1))

def visualize(pos: list[tuple[int, int]]) -> None:
    """ Hardcoded boundaries to work with given examples.
        Won't work with all input.
    """
    broke = False
    for y in range(15, -12, -1):
        for x in range(-12, 15):
            if pos[0] == (x, y):
                print('H', end='')
            elif (0, 0) == (x, y):
                print('s', end='')
            else:
                for i in range(1, len(pos)):
                    if pos[i] == (x, y):
                        print(i, end='')
                        broke = True
                        break
                if broke:
                    broke = False
                    continue
                print('.', end='')
        print()

def sim(rope: list[tuple[int, int]], motions: list[tuple[str, int]]) -> list[list[tuple[int, int]]]:
    pos = [rope]
    for m in motions:
        pos += move(pos[-1], m)

    return pos

def main() -> None:
    motions = [
        (line.split(' ')[0], int(line.split(' ')[1])) for line in stdin
    ]

    pos = sim([(0, 0), (0, 0)], motions)
    print(len(set([p[-1] for p in pos])))

    pos = sim([(0, 0) for _ in range(10)], motions)
    print(len(set([p[-1] for p in pos])))

if __name__ == '__main__':
    main()
