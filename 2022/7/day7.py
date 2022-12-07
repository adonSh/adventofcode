from sys import stdin

def dir_size(tree, dirname):
    return sum([
        f if isinstance(f, int) else dir_size(tree, f'{dirname}{f}/')
        for f in tree[dirname]
    ])

def parse_tree(cmds):
    path = []
    tree = {}

    for c in cmds:
        if c == '..':
            path.pop()
            continue

        path.append('' if c[0] == '/' else c[0])
        tree['/'.join(path) + '/'] = [
            int(f.split(' ')[0])
            if f.split(' ')[0].isnumeric() else f.split(' ')[1]
            for f in c[1]
        ]

    return tree

def p1(tree):
    return sum([
        dir_size(tree, dirname)
        for dirname in tree.keys() if dir_size(tree, dirname) <= 100000
    ])

def p2(tree):
    space_total     = 70000000
    space_needed    = 30000000
    space_used      = dir_size(tree, '/')
    space_available = space_total - space_used

    return min([
        dir_size(tree, dirname)
        for dirname in tree.keys()
        if space_available + dir_size(tree, dirname) >= space_needed
    ])

def main():
    tree = parse_tree([
        (ls[0][1:], ls[1].split('\n')) if len(ls) > 1 else ls[0][1:]
        for ls in [
            cd.split('\n$ ls\n')
            for cd in stdin.read().strip()[4:].split('\n$ cd')
        ]
    ])

    print(p1(tree))
    print(p2(tree))

if __name__ == '__main__':
    main()
