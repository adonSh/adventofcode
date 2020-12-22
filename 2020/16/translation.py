import sys

def contains(ranges, n):
    for v in ranges.values():
        if n in v[0] or n in v[1]:
            return True

    return False

def valid(ns, bad):
    for n in ns:
        if n in bad:
            return False

    return True

def p1(ranges, nearby):
    invalid = []

    for ns in nearby:
        for n in ns:
            if not contains(ranges, n):
                invalid.append(n)

    return invalid

def p2(ranges, tix):
    potential = {}

    for k, v in ranges.items():
        for i in range(len(tix[0])):
            if all([ (t[i] in v[0] or t[i] in v[1]) for t in tix  ]):
                if potential.get(k) is None:
                    potential[k] = set()
                potential[k].add(i)

    seen = set()
    while not all([ len(f) == 1 for f in potential.values() ]):
        cur = 0
        for v in potential.values():
            if len(v) == 1:
                cur = v.pop()
                v.add(cur)
                if cur not in seen:
                    seen.add(cur)
                    break
        for v in potential.values():
            if len(v) > 1:
                v.discard(cur)

    return potential

def main():
    ranges = {}
    nearby = []
    ticket = []

    for line in sys.stdin:
        l = line.strip()
        if l == '':
            break
        tokens = l.split(': ')

        rs = tokens[1].split()
        r1 = [ int(t) for t in rs[0].split('-') ]
        r2 = [ int(t) for t in rs[2].split('-') ]
        ranges[tokens[0]] = (range(r1[0], r1[1] + 1), range(r2[0], r2[1] + 1))

    for line in sys.stdin:
        l = line.strip()
        if l == '':
            break
        if l != 'your ticket:':
            ticket = [ int(t) for t in l.split(',') ]

    for line in sys.stdin:
        l = line.strip()
        if l != 'nearby tickets:':
            tokens = l.split(',')
            nearby.append([ int(t) for t in tokens ])

    # P1
    invalid = p1(ranges, nearby)
    print(sum(invalid))

    # P2
    tix = list(filter(lambda ns: valid(ns, invalid), nearby))
    fields = p2(ranges, tix)
    prod = 1
    for k, v in fields.items():
        if 'departure' in k:
            prod *= ticket[v.pop()]
    print(prod)

if __name__ == '__main__':
    main()
