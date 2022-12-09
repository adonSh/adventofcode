from sys import stdin

def visible(rows, cols, r, c):
    if r == 0 or r == len(rows) - 1:
        return True
    if c == 0 or c == len(rows[0]) - 1:
        return True

    if rows[r][c] > max(rows[r][:c]):
        return True
    if rows[r][c] > max(rows[r][c+1:]):
        return True
    if rows[r][c] > max(cols[c][:r]):
        return True
    if rows[r][c] > max(cols[c][r+1:]):
        return True

    return False

def scenic_score(rows, cols, r, c):
    left = 0
    for i in range(len(rows[r][:c])-1, -1, -1):
        left += 1
        if rows[r][i] >= rows[r][c]:
            break

    right = 0
    for i in range(len(rows[r][c+1:])):
        right += 1
        if rows[r][c+1:][i] >= rows[r][c]:
            break

    up = 0
    for i in range(len(cols[c][:r])-1, -1, -1):
        up += 1
        if cols[c][i] >= rows[r][c]:
            break

    down = 0
    for i in range(len(cols[c][r+1:])):
        down += 1
        if cols[c][r+1:][i] >= rows[r][c]:
            break

    return left * right * down * up

def main():
    rows = [[int(l) for l in line.strip()] for line in stdin]
    cols = [[r[i] for r in rows] for i in range(len(rows[0]))]
    visible_trees =  [
        rows[r][c] for c in range(len(cols))
        for r in range(len(rows)) if visible(rows, cols, r, c)
    ]
    scores = [
        scenic_score(rows, cols, r, c) for c in range(len(cols))
        for r in range(len(rows))
    ]

    print(len(visible_trees))
    print(max(scores))

if __name__ == '__main__':
    main()
