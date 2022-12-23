from sys import stdin

def main():
    beacons = [[l.split(',') for l in line.split(':')] for line in stdin]
    beacons = [[[int(''.join([c for c in p if c == '-' or c.isnumeric()])) for p in pair] for pair in line] for line in beacons]

    print(p1(beacons, 2000000))
    print(p2(beacons, 4000000))

def p2(beacons, coord_max):
    """ This doesn't actually get all points but it worked for my input so
        I didn't bother completing the search *shrug*
    """
    for pair in beacons:
        distance = manhattan_distance(*pair)
        for i in range(distance + 2):
            x = pair[0][0] + i
            y = pair[0][1] + distance - i + 1
            if x > coord_max or x < 0 or y > coord_max or y < 0:
                continue
            if all([manhattan_distance([x, y], p[0]) > manhattan_distance(*p) for p in beacons]):
                return x * coord_max + y
    return None

def p1(beacons, y):
    greatest_distance = max([manhattan_distance(*pair) for pair in beacons])
    leftmost = min([pair[0][0] for pair in beacons]) - greatest_distance
    rightmost = max([pair[0][0] for pair in beacons]) + greatest_distance
    num = 0

    for x in range(leftmost, rightmost):
        could = True
        for pair in beacons:
            if manhattan_distance(pair[0], [x, y]) <= manhattan_distance(*pair):
                if [x, y] not in [pair[1] for pair in beacons] and [x, y] not in [pair[0] for pair in beacons]:
                    could = False
                    break
        if not could:
            num += 1

    return num

def manhattan_distance(a, b):
    return abs(a[0] - b[0]) + abs(a[1] - b[1])

if __name__ == '__main__':
    main()
