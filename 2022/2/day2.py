from sys import stdin

moves = {
    'A': 'ROCK',
    'B': 'PAPER',
    'C': 'SCISSORS',
    'X': 'ROCK',
    'Y': 'PAPER',
    'Z': 'SCISSORS',
}

scores = {
    'ROCK': 1,
    'PAPER': 2,
    'SCISSORS': 3,
    'WIN': 6,
    'TIE': 3,
    'LOSS': 0,
}

def score(a, b):
    if moves[a] == moves[b]:
        return scores['TIE'] + scores[moves[b]]

    if moves[a] == 'ROCK':
        if moves[b] == 'PAPER':
            return scores['WIN'] + scores[moves[b]]
        if moves[b] == 'SCISSORS':
            return scores['LOSS'] + scores[moves[b]]
    if moves[a] == 'PAPER':
        if moves[b] == 'ROCK':
            return scores['LOSS'] + scores[moves[b]]
        if moves[b] == 'SCISSORS':
            return scores['WIN'] + scores[moves[b]]
    if moves[a] == 'SCISSORS':
        if moves[b] == 'ROCK':
            return scores['WIN'] + scores[moves[b]]
        if moves[b] == 'PAPER':
            return scores['LOSS'] + scores[moves[b]]

def calculate_move(a, b):
    results = {
        'X': 'LOSS',
        'Y': 'TIE',
        'Z': 'WIN',
    }

    if moves[a] == 'ROCK':
        if results[b] == 'LOSS':
            return 'Z'
        if results[b] == 'TIE':
            return 'X'
        if results[b] == 'WIN':
            return 'Y'
    if moves[a] == 'PAPER':
        if results[b] == 'LOSS':
            return 'X'
        if results[b] == 'TIE':
            return 'Y'
        if results[b] == 'WIN':
            return 'Z'
    if moves[a] == 'SCISSORS':
        if results[b] == 'LOSS':
            return 'Y'
        if results[b] == 'TIE':
            return 'Z'
        if results[b] == 'WIN':
            return 'X'

def main():
    rounds = [line.strip().split(' ') for line in stdin]

    print(sum([score(r[0], r[1]) for r in rounds]))
    print(sum([score(r[0], calculate_move(r[0], r[1])) for r in rounds]))

if __name__ == '__main__':
    main()
