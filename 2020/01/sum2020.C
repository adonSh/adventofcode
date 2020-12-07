#include <iostream>
#include <vector>

int p1(std::vector<int> ns)
{
    for (std::vector<int>::iterator it = ns.begin(); it != ns.end(); it++) {
        for (std::vector<int>::iterator it2 = it + 1; it2 != ns.end(); it2++) {
            if (*it + *it2 == 2020) {
                return *it * *it2;
            }
        }
    }
}

int p2(std::vector<int> ns)
{
    for (std::vector<int>::iterator it = ns.begin(); it != ns.end(); it++) {
        for (std::vector<int>::iterator it2 = it + 1; it2 != ns.end(); it2++) {
            for (std::vector<int>::iterator it3 = it2 + 1; it3 != ns.end(); it3++) {
                if (*it + *it2 + *it3 == 2020) {
                    return *it * *it2 * *it3;
                }
            }
        }
    }
}

int main(int argc, char *argv[])
{
    (void) argc;
    (void) argv;
    int n;
    std::vector<int> ns;

    while (std::cin >> n) {
        ns.push_back(n);
    }

    std::cout << p1(ns) << std::endl;
    std::cout << p2(ns) << std::endl;

    return 0;
}
