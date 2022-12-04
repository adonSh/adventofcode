from sys import stdin

def is_full_overlap(pair: list[range]) -> bool:
    if pair[0].start in pair[1] and pair[0].stop - 1 in pair[1]:
        return True

    if pair[1].start in pair[0] and pair[1].stop - 1 in pair[0]:
        return True

    return False

def overlaps_at_all(pair: list[range]) -> bool:
    return len(set(pair[0]).intersection(pair[1])) > 0

def main() -> None:
    pairs = [
        [range(int(p.split('-')[0]), int(p.split('-')[1]) + 1) for p in pair]
        for pair in [line.strip().split(',') for line in stdin]
    ]

    print(len([p for p in pairs if is_full_overlap(p)]))
    print(len([p for p in pairs if overlaps_at_all(p)]))

if __name__ == '__main__':
    main()
