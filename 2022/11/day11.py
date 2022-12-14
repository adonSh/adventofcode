from sys import stdin

def main():
    monkeys = [m.split('\n') for m in stdin.read().strip().split('\n\n')]

    print(p1([parse_monkey(m) for m in monkeys]))
    print(p2([parse_monkey(m) for m in monkeys]))

def p2(monkeys):
    lcm = 1
    for m in monkeys:
        lcm *= m['test'][0]

    for _ in range(10000):
        for i in range(len(monkeys)):
            monkey_business(monkeys, monkeys[i], lcm=lcm)

    nums = sorted([m['num'] for m in monkeys])
    return nums[-2] * nums[-1]

def p1(monkeys):
    for _ in range(20):
        for i in range(len(monkeys)):
            monkey_business(monkeys, monkeys[i])

    nums = sorted([m['num'] for m in monkeys])
    return nums[-2] * nums[-1]

def make_operation(spec):
    if spec[0] == '+':
        if spec[1] == 'old':
            return lambda x: x + x
        return lambda x: x + int(spec[1])
    if spec[0] == '*':
        if spec[1] == 'old':
            return lambda x: x * x
        return lambda x: x * int(spec[1])

def monkey_business(monkeys, m, lcm=0):
    while len(m['items']) > 0:
        item = m['items'][0]
        item = make_operation(m['operation'])(item)
        if lcm == 0:
            item = item // 3
        else:
            item = item % lcm
        if item % m['test'][0] == 0:
            monkeys[m['test'][1]]['items'].append(item)
        else:
            monkeys[m['test'][2]]['items'].append(item)
        m['items'] = m['items'][1:]
        m['num'] += 1

def parse_monkey(cfg):
    return {
        'monkey': int(cfg[0].split(' ')[1][0]),
        'items': [int(n) for n in cfg[1].split(':')[1].split(',')],
        'operation': (cfg[2].split(' ')[-2], cfg[2].split(' ')[-1]),
        'test': (int(cfg[3].split(' ')[-1]), int(cfg[4].split(' ')[-1]), int(cfg[5].split(' ')[-1])),
        'num': 0,
    }

if __name__ == '__main__':
    main()
