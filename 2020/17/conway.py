import sys

def contains(cubes, point):
    for i in range(len(cubes['x'])):
        if (cubes['x'][i] == point[0] and
            cubes['y'][i] == point[1] and
            cubes['z'][i] == point[2]):
            return True

    return False

def contains2(cubes, point):
    for i in range(len(cubes['x'])):
        if (cubes['x'][i] == point[0] and
            cubes['y'][i] == point[1] and
            cubes['z'][i] == point[2] and
            cubes['w'][i] == point[3]):
            return True

    return False

def countNeighbors(cubes, point):
    count = 0

    for i in range(len(cubes['x'])):
        dx = abs(cubes['x'][i] - point[0])
        dy = abs(cubes['y'][i] - point[1])
        dz = abs(cubes['z'][i] - point[2])
        if dx + dy + dz != 0:
            count += 1 if dx < 2 and dy < 2 and dz < 2 else 0

    return count

def countNeighbors2(cubes, point):
    count = 0

    for i in range(len(cubes['x'])):
        dx = abs(cubes['x'][i] - point[0])
        dy = abs(cubes['y'][i] - point[1])
        dz = abs(cubes['z'][i] - point[2])
        dw = abs(cubes['w'][i] - point[3])
        if dx + dy + dz + dw != 0:
            count += 1 if dx < 2 and dy < 2 and dz < 2 and dw < 2 else 0

    return count

def p1(cubes):
    newX = []
    newY = []
    newZ = []

    for i in range(len(cubes['x'])):
        cur = (cubes['x'][i], cubes['y'][i], cubes['z'][i])
        numNeighbs = countNeighbors(cubes, cur)
        if numNeighbs == 2 or numNeighbs == 3:
            newX.append(cur[0])
            newY.append(cur[1])
            newZ.append(cur[2])

    for z in range(min(cubes['z']) - 1, max(cubes['z']) + 2):
        for y in range(min(cubes['y']) - 1, max(cubes['y']) + 2):
            for x in range(min(cubes['x']) - 1, max(cubes['x']) + 2):
                cur = (x, y, z)
                if not contains(cubes, cur) and countNeighbors(cubes, cur) == 3:
                    newX.append(x)
                    newY.append(y)
                    newZ.append(z)

    cubes['x'] = newX
    cubes['y'] = newY
    cubes['z'] = newZ

    return cubes

def p2(cubes):
    newX = []
    newY = []
    newZ = []
    newW = []

    for i in range(len(cubes['x'])):
        cur = (cubes['x'][i], cubes['y'][i], cubes['z'][i], cubes['w'][i])
        numNeighbs = countNeighbors2(cubes, cur)
        if numNeighbs == 2 or numNeighbs == 3:
            newX.append(cur[0])
            newY.append(cur[1])
            newZ.append(cur[2])
            newW.append(cur[3])

    for w in range(min(cubes['w']) - 1, max(cubes['w']) + 2):
        for z in range(min(cubes['z']) - 1, max(cubes['z']) + 2):
            for y in range(min(cubes['y']) - 1, max(cubes['y']) + 2):
                for x in range(min(cubes['x']) - 1, max(cubes['x']) + 2):
                    cur = (x, y, z, w)
                    if not contains2(cubes, cur) and countNeighbors2(cubes, cur) == 3:
                        newX.append(x)
                        newY.append(y)
                        newZ.append(z)
                        newW.append(w)

    cubes['x'] = newX
    cubes['y'] = newY
    cubes['z'] = newZ
    cubes['w'] = newW

    return cubes

def main():
    cubes = { 'x': [], 'y': [], 'z': [] }
    cubes2 = { 'x': [], 'y': [], 'z': [], 'w': [] }
    i = 0
    for line in sys.stdin:
        for c in range(len(line)):
            if line[c] == '#':
                cubes['y'].append(i)
                cubes['x'].append(c)
                cubes['z'].append(0)

                cubes2['y'].append(i)
                cubes2['x'].append(c)
                cubes2['z'].append(0)
                cubes2['w'].append(0)
        i += 1

    # P1
    for _ in range(6):
        cubes = p1(cubes)
    print(len(cubes['x']))

    # P2
    for _ in range(6):
        cubes2 = p2(cubes2)
    print(len(cubes2['x']))

if __name__ == '__main__':
    main()
