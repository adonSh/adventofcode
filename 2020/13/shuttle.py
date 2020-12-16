import sys

def p1(busID, actual, desired):
    if actual >= desired:
        return actual

    return p1(busID, actual + busID, desired)

def p2(buses):
    """ Gave up on this one too. All credit to u/imbadatreading from Reddit """
    bi = list(buses.items())
    lcm = 1
    time = 0

    for i in range(len(bi) - 1):
        start = bi[i+1][0]
        busid = bi[i+1][1]
        lcm *= bi[i][1]
        while (time + start) % busid != 0:
            time += lcm

    return time

def main():
    etd = -1
    buses1 = []
    buses2 = {}

    for line in sys.stdin:
        etd = int(line.strip())
        break
    for line in sys.stdin:
        l = line.strip().split(',')
        buses = list(map(lambda x: int(x), filter(lambda x: x != 'x', l)))
        for i in range(len(l)):
            if l[i] != 'x':
                buses2[i] = int(l[i])

    # Bumped into Python's recursion limit
    import resource
    resource.setrlimit(resource.RLIMIT_STACK, (2**29,-1))
    sys.setrecursionlimit(etd)

    earliest = (buses[0], p1(buses[0], 0, etd))
    for b in buses[1:]:
        time = p1(b, 0, etd)
        earliest = (b, time) if time < earliest[1] else earliest

    print(earliest[0] * (earliest[1] - etd))
    print(p2(buses2))

if __name__ == '__main__':
    main()
