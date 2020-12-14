import sys

def copy(grid):
    new = []

    for row in grid:
        r = []
        for seat in row:
            r.append(seat)
        new.append(r)

    return new

def occupied(grid):
    count = 0

    for row in grid:
        for seat in row:
            count += 1 if seat == '#' else 0

    return count

def adjacent(grid, row, seat):
    count = 0

    if row > 0:
        count += 1 if grid[row-1][seat] == '#' else 0
    if row < len(grid) - 1:
        count += 1 if grid[row+1][seat] == '#' else 0
    if seat > 0:
        count += 1 if grid[row][seat-1] == '#' else 0
    if seat < len(grid[row]) - 1:
        count += 1 if grid[row][seat+1] == '#' else 0
    if row > 0 and seat > 0:
        count += 1 if grid[row-1][seat-1] == '#' else 0
    if row > 0 and seat < len(grid[row]) - 1:
        count += 1 if grid[row-1][seat+1] == '#' else 0
    if row < len(grid) - 1 and seat > 0:
        count += 1 if grid[row+1][seat-1] == '#' else 0
    if row < len(grid) - 1 and seat < len(grid[row]) - 1:
        count += 1 if grid[row+1][seat+1] == '#' else 0

    return count

def p1(grid):
    changes = 0
    changesP = -1
    gridC = copy(grid)
    gridP = copy(grid)

    while changes != changesP:
        changesP = changes
        for row in range(len(grid)):
            for seat in range(len(grid[row])):
                if gridP[row][seat] == 'L' and adjacent(gridP, row, seat) == 0:
                    gridC[row][seat] = '#'
                    changes += 1
                if gridP[row][seat] == '#' and adjacent(gridP, row, seat) > 3:
                    gridC[row][seat] = 'L'
                    changes += 1
        gridP = copy(gridC)

#       for row in gridC:
#           for seat in row:
#               print(seat, end='')
#           print()
#       print(changes, changesP)
    return occupied(gridC)

def visible(grid, row, seat):
    count = 0

    r = row
    s = seat
    while r > 0:
        r -= 1
        if grid[r][s] != '.':
            count += 1 if grid[r][s] == '#' else 0
            break
    r = row
    s = seat
    while r < len(grid) - 1:
        r += 1
        if grid[r][s] != '.':
            count += 1 if grid[r][s] == '#' else 0
            break
    r = row
    s = seat
    while s > 0:
        s -= 1
        if grid[r][s] != '.':
            count += 1 if grid[r][s] == '#' else 0
            break
    r = row
    s = seat
    while s < len(grid[r]) - 1:
        s += 1
        if grid[r][s] != '.':
            count += 1 if grid[r][s] == '#' else 0
            break
    r = row
    s = seat
    while r > 0 and s > 0:
        r -= 1
        s -= 1
        if grid[r][s] != '.':
            count += 1 if grid[r][s] == '#' else 0
            break
    r = row
    s = seat
    while r > 0 and s < len(grid[r]) - 1:
        r -= 1
        s += 1
        if grid[r][s] != '.':
            count += 1 if grid[r][s] == '#' else 0
            break
    r = row
    s = seat
    while r < len(grid) - 1 and s > 0:
        r += 1
        s -= 1
        if grid[r][s] != '.':
            count += 1 if grid[r][s] == '#' else 0
            break
    r = row
    s = seat
    while r < len(grid) - 1 and s < len(grid[r]) - 1:
        r += 1
        s += 1
        if grid[r][s] != '.':
            count += 1 if grid[r][s] == '#' else 0
            break

    return count

def p2(grid):
    changes = 0
    changesP = -1
    gridC = copy(grid)
    gridP = copy(grid)

    while changes != changesP:
        changesP = changes
        for row in range(len(grid)):
            for seat in range(len(grid[row])):
                if gridP[row][seat] == 'L' and visible(gridP, row, seat) == 0:
                    gridC[row][seat] = '#'
                    changes += 1
                if gridP[row][seat] == '#' and visible(gridP, row, seat) > 4:
                    gridC[row][seat] = 'L'
                    changes += 1
        gridP = copy(gridC)

    return occupied(gridC)

def main():
    grid = []

    for line in sys.stdin:
        grid.append(list(line.strip()))

    print(p1(grid))
    print(p2(grid))

if __name__ == '__main__':
    main()
