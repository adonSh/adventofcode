import sys

def p1(ns, nth):
    d = {}
    cur = 0
    prev = ns[-1]

    for i in range(len(ns)):
        d[ns[i]] = i

    for i in range(len(ns), nth):
        cur = i - 1 - d.get(prev, i - 1)
        d[prev] = i - 1
        prev = cur

    return cur

def main():
    ns = list(map(lambda n: int(n), sys.stdin.readline().strip().split(',')))

    print(p1(ns, 2020))
    print(p1(ns, 30000000))

if __name__ == '__main__':
    main()
