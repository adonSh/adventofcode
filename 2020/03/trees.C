#include <iostream>
#include <vector>

int findPattern(std::string line)
{
    int n = 0;

    for (long unsigned int i = 2; i < line.size(); i++) {
        if (line.size() % i == 0) {
            int size = line.size() / i;
            if (line.substr(0, size) != line.substr(size, size)) {
                return n;
            }
            n = size;
        }
    }

    if (n == 0) {
        return line.size();
    }

    return n;
}

int checkSlope(int right, int down, std::vector<std::string> lines)
{
    const char TREE = '#';
    int pos = 0;
    int total = 0;

    for (long unsigned int i = 0; i < lines.size(); i = i + down) {
        if (lines[i][pos] == TREE) {
            total++;
        }
        pos = (pos + right) % lines[i].size();
    }

    return total;
}

int main(int argc, char *argv[])
{
    (void) argc;
    (void) argv;
    std::vector<std::string> lines;
    std::string l;
    int n;
    std::vector<int> counts;

    std::cin >> l;
    n = findPattern(l);
    lines.push_back(l.substr(0, n));
    while (std::cin >> l) {
        lines.push_back(l.substr(0, n));
    }

    for (int i = 0; i < 5; i++)
        counts.push_back(0);
    
    /* Part 1 */
    counts[0] = checkSlope(3, 1, lines);
    std::cout << counts[0] << std::endl;

    /* Part 2 */
    counts[1] = checkSlope(1, 1, lines);
    counts[2] = checkSlope(5, 1, lines);
    counts[3] = checkSlope(7, 1, lines);
    counts[4] = checkSlope(1, 2, lines);

    int total = 1;
    for (long unsigned int i = 0; i < counts.size(); i++) {
        total = total * counts[i];
    }
    std::cout << total << std::endl;

    return 0;
}
