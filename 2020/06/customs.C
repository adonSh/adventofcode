#include <iostream>
#include <map>
#include <vector>

template<class T>
struct Set {
    std::map<T, int> m;
};

int main(void)
{
    std::string line;
    std::vector<Set<char>> sets;
    Set<char> s = Set<char>();
    int n = 0;
    int total1 = 0;
    int total2 = 0;

    while (getline(std::cin, line)) {
        if (line.empty()) {
            s.m['!'] = n;
            n = 0;
            sets.push_back(s);
            s = Set<char>();
            continue;
        }

        for (long unsigned int i = 0; i < line.size(); i++) {
            s.m[line[i]] += 1;
        }
        n++;
    }
    s.m['!'] = n;
    sets.push_back(s);

    for (long unsigned int i = 0; i < sets.size(); i++) {
        total1 += sets[i].m.size() - 1;

        for (std::map<char, int>::iterator it = sets[i].m.begin(); it != sets[i].m.end(); it++) {
            if (it->first != '!' && it->second == sets[i].m['!']) {
                total2 += 1;
            }
        }
    }

    std::cout << total1 << std::endl;
    std::cout << total2 << std::endl;

    return 0;
}
