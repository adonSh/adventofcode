import enum
import sys

X = 0
Y = 1
DIR = 2
WX = 3
WY = 4

class Dir(enum.Enum):
    N = 0
    E = 1
    S = 2
    W = 3
    R = 4
    L = 5
    F = 6

def adjust1(state, action, quant):
    if action == Dir.N:
        return (state[X], state[Y] + quant, state[DIR])
    elif action == Dir.S:
        return (state[X], state[Y] - quant, state[DIR])
    elif action == Dir.E:
        return (state[X] + quant, state[Y], state[DIR])
    elif action == Dir.W:
        return (state[X] - quant, state[Y], state[DIR])
    elif action == Dir.R:
        return (state[X], state[Y], Dir((state[DIR].value + (quant / 90)) % 4))
    elif action == Dir.L:
        return (state[X], state[Y], Dir((state[DIR].value - (quant / 90)) % 4))
    elif action == Dir.F:
        return adjust1(state, state[DIR], quant)

    return state

def distance(x, y):
    return abs(x) + abs(y)

def adjust2(state, action, quant):
    if action == Dir.N:
        return (state[X], state[Y], state[DIR], state[WX], state[WY] + quant)
    elif action == Dir.S:
        return (state[X], state[Y], state[DIR], state[WX], state[WY] - quant)
    elif action == Dir.E:
        return (state[X], state[Y], state[DIR], state[WX] + quant, state[WY])
    elif action == Dir.W:
        return (state[X], state[Y], state[DIR], state[WX] - quant, state[WY])
    elif action == Dir.R:
        if quant == 0:
            return state
        else:
            return adjust2((state[X], state[Y], state[DIR], state[WY], -state[WX]), action, quant - 90)
    elif action == Dir.L:
        if quant == 0:
            return state
        else:
            return adjust2((state[X], state[Y], state[DIR], -state[WY], state[WX]), action, quant - 90)
    elif action == Dir.F:
        return (
            state[X] + (quant * state[WX]),
            state[Y] + (quant * state[WY]),
            state[DIR],
            state[WX],
            state[WY],
        )

    return state

def main():
    state1 = (0, 0, Dir.E)
    state2 = (0, 0, Dir.E, 10, 1)

    for line in sys.stdin:
        state1 = adjust1(state1, Dir[line[0]], int(line[1:]))
        state2 = adjust2(state2, Dir[line[0]], int(line[1:]))
        
    print(distance(state1[X], state1[Y]))
    print(distance(state2[X], state2[Y]))

if __name__ == '__main__':
    main()
