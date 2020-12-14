INDEX   = 0
ACC     = 1
PROGRAM = 2

ops = {
    'nop': lambda c, n: newConsole(c[INDEX] + 1, c[ACC], c[PROGRAM]),
    'acc': lambda c, n: newConsole(c[INDEX] + 1, c[ACC] + n, c[PROGRAM]),
    'jmp': lambda c, n: newConsole(c[INDEX] + n, c[ACC], c[PROGRAM]),
}

class Op:
    def __init__(self, nm, quant):
        self.name = nm
        self.quantity = quant

def newConsole(index, acc, prgrm):
    return (index, acc, prgrm)

def operate(console):
    if console[INDEX] >= len(console[PROGRAM]):
        return console

    op = console[PROGRAM][console[INDEX]]
    return ops[op.name](console, op.quantity)

def parse(raw):
    parsed = []
    for line in raw:
        tokens = line.split()
        parsed.append(Op(tokens[0], int(tokens[1])))

    return parsed
