import sys

def satisfies(rules, rule, string):
    pos = 0
    rlen = ruleLen(rules, rule)
    if len(string) != rlen:
        return False

    for r in rule:
        print(r)
        return satisfies(rules, rules[r], string[pos:rlen])
        
    return False

def ruleLen(rules, rule):
    l = 0

    for r in rule:
        if isinstance(r, str):
            l += len(r)
        elif isinstance(r, int):
            l += ruleLen(rules, rules[r])
        elif isinstance(r, list):
            l += ruleLen(rules, r) / len(rule)

    return int(l)

def p1(rules, inputs):
#   length = ruleLen(rules, rules[0])
    count = 0

    count += 1 if satisfies(rules, rules[0], inputs[0]) else 0
#   for i in inputs:
#       if len(i) != length:
#           continue
#       if not satisfies(rules, rules[0], i):
#           continue
#       count += 1

    return count 

def main():
    rules = {}

    for line in sys.stdin:
        if line == '\n':
            break
        l = line.strip().split(':')
        rule = [ t.split() for t in l[1].split('|') ]
        if len(rule) == 1:
            if rule[0][0][0] == '"':
                rules[int(l[0])] = [ rule[0][0][1] ]
            else:
                rules[int(l[0])] = list(map(lambda x: int(x), rule[0]))
        else:
            rules[int(l[0])] = [ list(map(lambda x: int(x), r)) for r in rule ]

    inputs = [ line.strip() for line in sys.stdin ]
 
#   print(rules)
#   print(inputs)
    print(p1(rules, inputs))

if __name__ == '__main__':
    main()
