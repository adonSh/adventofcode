#include <algorithm>
#include <iostream>
#include <vector>

std::string toBin(std::string s)
{
    std::string bin;

    for (long unsigned int i = 0; i < 7; i++) {
        if (s[i] == 'F') {
            bin += "0";
        } else if (s[i] == 'B') {
            bin += "1";
        }
    }

    for (long unsigned int i = 7; i < s.size(); i++) {
        if (s[i] == 'L') {
            bin += "0";
        } else if (s[i] == 'R') {
            bin += "1";
        }
    }

    return bin;
}

int main(void)
{
    int highest = 0;
    std::string l;
    std::vector<int> ids;

    while (std::cin >> l) {
        int id = std::stoi(toBin(l), nullptr, 2);
        
        ids.push_back(id);
        highest = (id > highest) ? id : highest;
    }

    std::cout << highest << std::endl;

    for (long unsigned int i = 0; i < ids.size(); i++) {
        if (find(ids.begin(), ids.end(), i + 1) == ids.end() && find(ids.begin(), ids.end(), i + 2) != ids.end())
            std::cout << i + 1 << std::endl;
    }

    return 0;
}
