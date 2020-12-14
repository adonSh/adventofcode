import sys

LEN = 25

def p1(ns):
    for i in range(LEN, len(ns)):
        acc = True
        for j in  range(i - LEN, i - 1):
            for k in range(j + 1, i):
                acc &= ns[j] + ns[k] != ns[i]
        if acc:
            return ns[i]

    return -1

def p2(ns, sm):
    for i in range(len(ns) - 1):
        for j in range(i + 1, len(ns)):
            if sum(ns[i:j]) == sm:
                return min(ns[i:j]) + max(ns[i:j])

    return -1

def main():
    ns = []

    for line in sys.stdin:
        ns.append(int(line))

    ans1 = p1(ns)
    print(ans1)
    print(p2(ns, ans1))

if __name__ == '__main__':
    main()
