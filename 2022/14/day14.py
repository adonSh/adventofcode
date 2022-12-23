from sys import stdin

def main():
    lines = [
        [
            [int(p) for p in pair.split(',')]
            for pair in line.strip().split(' -> ')
        ] for line in stdin
    ]

    all_points = []
    for l in lines:
        for i in range(1, len(l)):
            if l[i-1][0] == l[i][0]:
                all_points += [(l[i][0], y) for y in range(min(l[i-1][1], l[i][1]), max(l[i-1][1], l[i][1]) + 1)]
            if l[i-1][1] == l[i][1]:                                                                          
                all_points += [(x, l[i][1]) for x in range(min(l[i-1][0], l[i][0]), max(l[i-1][0], l[i][0]) + 1)]

    print(p1(populate(all_points)))
    print(p2(populate(all_points)))

def p2(grid):
    spout = grid[0].index('+')
    grid.append(['.' for _ in range(len(grid[0]))])
    grid.append(['#' for _ in range(len(grid[0]))])

    gos = 0
    while True:
        drop_sand(grid, 0, spout)
        gos = count(grid)
        if grid[0][spout] == 'o':
            break

#   draw(grid)
    return gos

def p1(grid):
    spout = grid[0].index('+')

    gos = 0
    while True:
        drop_sand(grid, 0, spout)
        if count(grid) > gos:
            gos = count(grid)
        else:
            break

#   draw(grid)
    return gos

def count(grid):
    return sum([sum([1 for c in row if c == 'o']) for row in grid])

def place_grain(grid, row, col):
    if grid[row][col-1] == '.':
        drop_sand(grid, row, col-1)
        return
    if grid[row][col+1] == '.':
        drop_sand(grid, row, col+1)
        return
    grid[row-1][col] = 'o'

def drop_sand(grid, row, col):
    if col < 0 or col >= len(grid[0]):
        return

    for row in range(row + 1, len(grid)):
        if grid[row][col] != '.':
            place_grain(grid, row, col)
            return

def draw(grid):
    for row in grid:
        for col in row:
            print(col, end='')
        print()

def populate(lines):
    grid = []
    xs = [p[0] for p in lines]
    ys = [p[1] for p in lines]

    for row in range(0, max(ys) + 1):
        grid.append([])
#       for col in range(min(xs), max(xs) + 1):
        for col in range(0, 2 * max(xs) + 1):
            if row == 0 and col == 500:
                grid[row].append('+')
            elif (col, row) in lines:
                grid[row].append('#')
            else:
                grid[row].append('.')

    return grid

if __name__ == '__main__':
    main()
