import sys

def p1(ns):
    sns = [0] + sorted(ns) + [max(ns) + 3]
    d1 = 0
    d3 = 0

    for i in range(1, len(sns)):
        if sns[i] - sns[i-1] == 1:
            d1 += 1
        elif sns[i] - sns[i-1] == 3:
            d3 += 1

    return d1 * d3

def p2(ns):
    """All credit to u/j3r3mias from Reddit for this. I got lazy with this one.
    """
    sns = sorted(ns) + [max(ns) + 3]
    ps = {0: 1}

    for n in sns:
        ps[n] = ps.get(n - 1, 0) + ps.get(n - 2, 0) + ps.get(n - 3, 0)

    return ps[sns[-1]]

def main():
    adapters = []

    for line in sys.stdin:
        adapters.append(int(line))

    print(p1(adapters))
    print(p2(adapters))

if __name__ == '__main__':
    main()
