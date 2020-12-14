import sys

import handheld

def run(console, seen):
    i = console[handheld.INDEX]
    count = seen.get(i)
    seen[i] = 1 if count is None else count + 1

    if seen[i] > 1:
        return (console[handheld.ACC], i == len(console[handheld.PROGRAM]))

    return run(handheld.operate(console), seen)

def p1(console):
    return run(console, {})[0]

def p2(console):
    for i in range(len(console[handheld.PROGRAM])):
        orig = console[handheld.PROGRAM][i].name
        if orig == 'nop':
            console[handheld.PROGRAM][i].name = 'jmp'
        elif orig == 'jmp':
            console[handheld.PROGRAM][i].name = 'nop'

        result, succeeded = run(console, {})
        console[handheld.PROGRAM][i].name = orig

        if succeeded:
            return result

    return "ERROR"

def main():
    console = handheld.newConsole(0, 0, handheld.parse(sys.stdin))

    try:
        print(p1(console))
        print(p2(console))
    except KeyboardInterrupt:
        print('\nCancelled')

if __name__ == '__main__':
    main()
