#include <iostream>
#include <sstream>
#include <string>

int count(char c, std::string s)
{
    int total = 0;

    for (long unsigned int i = 0; i < s.size(); i++) {
        if (s[i] == c) {
            total++;
        }
    }

    return total;
}

bool valid(int min, int max, char key, std::string passwd)
{
    int c = count(key, passwd);

    if (c <= max && c >= min) {
        return true;
    }

    return false;
}

bool valid2(int p1, int p2, char key, std::string passwd)
{
    return ((passwd[p1-1] == key || passwd[p2-1] == key) && passwd[p1-1] != passwd[p2-1]);
}

int main(int argc, char *argv[])
{
    (void) argc;
    (void) argv;
    std::string line;
    int total1 = 0;
    int total2 = 0;

    while (getline(std::cin, line)) {
        std::stringstream l(line);
        std::string a, b, c;

        l >> a;
        l >> b;
        l >> c;

        std::string min = a.substr(0, a.find("-"));
        a.erase(0, a.find("-") + 1);

        if (valid(atoi(min.c_str()), atoi(a.c_str()), b[0], c)) {
            total1++;
        }

        if (valid2(atoi(min.c_str()), atoi(a.c_str()), b[0], c)) {
            total2++;
        }
    }

    std::cout << total1 << std::endl << total2 << std::endl;

    return 0;
}
