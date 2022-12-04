from sys import stdin

def priority(a: str) -> int:
    return ord(a) - 96 if a.islower() else ord(a) - 38

def p1(sacks: list[tuple[str, str]]) -> int:
    common = []
    for s in sacks:
        for t in s[0]:
            if t in s[1]:
                common.append(t)
                break

    return sum(map(priority, common))

def p2(sacks: list[str]) -> int:
    badges = []
    for i in range(0, len(sacks), 3):
        for t in sacks[i]:
            if t in sacks[i+1] and t in sacks[i+2]:
                badges.append(t)
                break

    return sum(map(priority, badges))

def main() -> None:
    lines = [l.strip() for l in stdin]
    sacks = [(l[:len(l)//2], l[len(l)//2:]) for l in lines]

    print(p1(sacks))
    print(p2(lines))

if __name__ == '__main__':
    main()
