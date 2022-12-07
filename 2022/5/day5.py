from sys import stdin

def parse_stacks(crates: str) -> dict[int, list[str]]:
    stacks: dict[int, list[str]] = {}
    positions: dict[int, int] = {}
    rows = crates.split('\n')

    for col in range(len(rows[-1])):
        if rows[-1][col].isnumeric():
            positions[col] = int(rows[-1][col])
            stacks[positions[col]] = []

    for row in reversed(rows[:-1]):
        for col in range(len(row)):
            if row[col].isalpha():
                stacks[positions[col]].append(row[col])

    return stacks

def p1(stacks: dict[int, list[str]], moves: list[list[int]]) -> str:
    for m in moves:
        for i in range(m[0]):
            stacks[m[2]].append(stacks[m[1]].pop())

    return ''.join([s[-1] for s in stacks.values()])

def p2(stacks: dict[int, list[str]], moves: list[list[int]]) -> str:
    for m in moves:
        stacks[m[2]] += stacks[m[1]][-m[0]:]
        stacks[m[1]] = stacks[m[1]][:-m[0]]

    return ''.join([s[-1] for s in stacks.values()])

def main() -> None:
    crates, procedure = stdin.read().split('\n\n')
    moves = [
        [int(word) for word in p.split(' ') if word.isnumeric()]
        for p in procedure.strip().split('\n')
    ]

    print(p1(parse_stacks(crates), moves))
    print(p2(parse_stacks(crates), moves))

if __name__ == '__main__':
    main()
