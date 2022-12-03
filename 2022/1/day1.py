from sys import stdin

def p1(ns):
    return max(map(sum, ns))

def p2(ns):
    return sum(sorted(map(sum, ns))[-3:])

def main():
    lines = [line.strip() for line in stdin]
    elves = [[]]
    for l in lines:
        if l == '':
            elves.append([])
        else:
            elves[-1].append(int(l))

    print(p1(elves))
    print(p2(elves))

if __name__ == '__main__':
    main()
