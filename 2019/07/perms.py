import itertools

ps = itertools.permutations([5,6,7,8,9])

for p in ps:
    for i in p:
        print(i)
