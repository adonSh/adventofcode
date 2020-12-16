import sys

class State:
    def __init__(self):
        self.mask = ''
        self.mem = {}

    def write1(self, addr, num):
        n = format(num, '036b')
        self.mem[addr] = ''.join([ n[i] if self.mask[i] == 'X' else self.mask[i] for i in range(len(n)) ])

    def write2(self, addr, num):
        n = format(addr, '036b')
        addrs = [ ''.join([ n[i] if self.mask[i] == '0' else self.mask[i] for i in range(len(n)) ]) ]

        while containsX(addrs):
            for i in  range(len(addrs)):
                addrs.append(addrs[i].replace('X', '1', 1))
                addrs[i] = addrs[i].replace('X', '0', 1)

        for a in addrs:
            self.mem[int(a, 2)] = format(num, '036b')

    def sumMem(self):
        total = 0

        for k, v in self.mem.items():
            total += int(v, 2)

        return total

    def __str__(self):
        return '\n'.join([ f'mask: {self.mask}' ] + [ f'mem[{k}]: {v}' for k, v in self.mem.items() ])

def containsX(lsts):
    acc = False

    for s in lsts:
        acc = acc or 'X' in s

    return acc

def main():
    state1 = State()
    state2 = State()

    for line in sys.stdin:
        l = line.strip().split()
        if l[0] == 'mask':
            state1.mask = l[2]
            state2.mask = l[2]
        elif l[0][:3] == 'mem':
            state1.write1(int(l[0][4:-1]), int(l[2]))
            state2.write2(int(l[0][4:-1]), int(l[2]))

#   print(state1)
    print(state1.sumMem())
    print(state2.sumMem())

if __name__ == '__main__':
    main()
