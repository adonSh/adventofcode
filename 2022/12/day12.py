from sys import stdin

def main():
    rows = stdin.read().strip().split('\n')
    grid = {}
    for y in range(len(rows)):
        for x in range(len(rows[y])):
            grid[(x, y)] = ord(rows[len(rows)-1-y][x]) - ord('a')
            if rows[len(rows)-1-y][x] == 'S':
                grid[(x, y)] = ord('a') - ord('a')
                start = (x, y)
            if rows[len(rows)-1-y][x] == 'E':
                grid[(x, y)] = ord('z') - ord('a')
                end = (x, y)

    print(search(grid, start, end))
    print(min([search(grid, pt, end) for pt, ht in grid.items() if ht == 0]))

def search(grid, cur, end):
    seen = set([cur])
    q = [(cur, 0)]

    while len(q) > 0:
        v, steps = q[0]
        if v == end:
            return steps

        for n in neighbors_of(grid, v):
            if n not in seen:
                seen.add(n)
                q.append((n, steps + 1))

        q = q[1:]

    return float('inf')

def neighbors_of(grid, cur):
    right = (cur[0]+1, cur[1])
    left = (cur[0]-1, cur[1])
    up = (cur[0], cur[1]+1)
    down = (cur[0], cur[1]-1)
    neighbors = []

    if grid.get(right) is not None:
        if grid[right] - grid[cur] < 2:
            neighbors.append(right)
    if grid.get(left) is not None:
        if grid[left] - grid[cur] < 2:
            neighbors.append(left)
    if grid.get(up) is not None:
        if grid[up] - grid[cur] < 2:
            neighbors.append(up)
    if grid.get(down) is not None:
        if grid[down] - grid[cur] < 2:
            neighbors.append(down)

    return neighbors

if __name__ == '__main__':
    main()
