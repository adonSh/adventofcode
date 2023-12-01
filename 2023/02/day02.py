def get_input(file):
    return quantize([line.strip()[5:].split(':') for line in file])

def part1(games):
    cubes = {'red': 12, 'green': 13, 'blue': 14}
    return sum([
        gid for gid, rounds in games.items()
        if all([is_possible(r, cubes) for r in rounds])
    ])

def part2(games):
    return sum([
        max([r.get('red', 0) for r in game]) *
        max([r.get('green', 0) for r in game]) *
        max([r.get('blue', 0) for r in game])
        for game in games.values()
    ])

def is_possible(rnd, cnts):
    return (rnd.get('red', 0) <= cnts['red'] and
            rnd.get('green', 0) <= cnts['green'] and
            rnd.get('blue', 0) <= cnts['blue'])

def quantize(games):
    return {
        int(g[0]): [
            {ps.split(' ')[-1]: int(ps.split(' ')[1]) for ps in r.split(',')}
            for r in g[-1].split(';')
        ] for g in games
    }
