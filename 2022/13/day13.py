from functools import cmp_to_key
from sys import stdin

def main():
    packets = [
        [eval(p) for p in pair.split('\n')]
        for pair in stdin.read().strip().split('\n\n')
    ]
    ordered_pairs = [i+1 for i in range(len(packets)) if compare(*packets[i])]
    all_sorted = sorted([[[2]], [[6]]] + [p for pair in packets for p in pair],
                        key=cmp_to_key(lambda a, b: -1 if compare(a, b) else 1))

    print(sum(ordered_pairs))
    print((all_sorted.index([[2]]) + 1) * (all_sorted.index([[6]]) + 1))

def compare(left, right):
    for i in range(min(len(left), len(right))):
        if isinstance(left[i], int) and isinstance(right[i], int):
            if left[i] < right[i]:
                return True
            if left[i] > right[i]:
                return False
        elif isinstance(left[i], list) and isinstance(right[i], list):
            if (res := compare(left[i], right[i])) is not None:
                return res
        elif isinstance(left[i], int):
            if (res := compare([left[i]], right[i])) is not None:
                return res
        elif isinstance(right[i], int):
            if (res := compare(left[i], [right[i]])) is not None:
                return res

    if len(left) == len(right):
        return None
    return len(left) < len(right)

if __name__ == '__main__':
    main()
