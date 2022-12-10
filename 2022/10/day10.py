from sys import stdin

class State:
    def __init__(self, program):
        self.X = 1
        self.clock = 0
        self.program = program
        self.queue = []
        self.ip = 0

    def cycle(self):
        """ Advances to the next state but returns the
            X value from the *beginning* of the cycle.
        """
        self.clock += 1
        val = self.X

        if len(self.queue) > 0:
            self.X += self.queue[0][1]
            self.queue = self.queue[1:]
            return val

        if self.ip >= len(self.program):
            return val

        if self.program[self.ip][0] == 'addx':
            self.queue.append(self.program[self.ip])

        self.ip += 1
        return val

def main():
    instructions = [
        (line.strip().split(' ')[0], int(line.split(' ')[1]) if len(line.split(' ')) > 1 else None)
        for line in stdin
    ]
    cpu = State(instructions)
    states = [cpu.cycle() for _ in range(240)]
    display = [
        '#' if i % 40 in range(states[i] - 1, states[i] + 2) else ' '
        for i in range(len(states))
    ]

    print(sum([i * states[i-1] for i in range(20, len(states), 40)]))
    print('\n'.join([
        ''.join(display[i:i+39]) for i in range(0, len(display), 40)
    ]))

if __name__ == '__main__':
    main()
