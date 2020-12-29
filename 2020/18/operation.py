import sys

ops = {
    '+': lambda x, y: x + y,
    '*': lambda x, y: x * y,
}

def findMatching(tokens, start):
    others = 0

    for i in range(start + 1, len(tokens)):
        if tokens[i] == '(':
            others += 1
        if tokens[i] == ')':
            if others == 0:
                return i
            others -= 1

    return -1

def parse(tokens):
    parsed = []

    i = 0
    while i < len(tokens):
        if tokens[i].isnumeric():
            parsed.append(int(tokens[i]))
        elif tokens[i] in ops:
            parsed.append(tokens[i])
        else:
            end = findMatching(tokens, i)
            parsed.append(parse(tokens[i+1:end]))
            i = end
        i += 1

    return parsed

def shuntingYard(tokens):
    output = []
    operators = []

    for t in tokens:
        if isinstance(t, list):
            output += shuntingYard(t)
        elif t in ops:
            while len(operators) > 0:
                output.append(operators.pop())
            operators.append(t)
        else:
            output.append(t)

    while len(operators) > 0:
        output.append(operators.pop())

    return output

def shuntingWithPrecedence(tokens):
    output = []
    operators = []

    for t in tokens:
        if isinstance(t, list):
            output += shuntingWithPrecedence(t)
        elif t in ops:
            # Conveniently, the string '+' is greater than '*', matching the
            # desired operator precedence
            while len(operators) > 0 and operators[-1] > t:
                output.append(operators.pop())
            operators.append(t)
        else:
            output.append(t)

    while len(operators) > 0:
        output.append(operators.pop())

    return output

def rpn(queue):
    stack = []

    for q in queue:
        if q in ops:
            stack.append(ops[q](stack.pop(), stack.pop()))
        else:
            stack.append(q)

    return stack.pop()

def p1(lines):
    return sum([ rpn(shuntingYard(parse(line))) for line in lines ])

def p2(lines):
    return sum([ rpn(shuntingWithPrecedence(parse(line))) for line in lines ])

def tokenize(line):
    tokens = []

    for w in line:
        if w == '+' or w == '*' or w.isnumeric():
            tokens.append(w)
        else:
            n = ''
            parens = []
            for c in w:
                if c == '(':
                    tokens.append(c)
                elif c == ')':
                    parens.append(c)
                else:
                    n += c
            tokens.append(n)
            tokens += parens

    return tokens

def main():
    lines = [ tokenize(line.strip().split()) for line in sys.stdin ]
    print(p1(lines))
    print(p2(lines))

if __name__ == '__main__':
    main()
