#include <iostream>
#include <map>
#include <sstream>
#include <vector>

class Node {
    public:
        Node(std::string, int);
        ~Node();
        std::string getColor();
        int getAmount();
        void insert(Node *);
        std::vector<Node *> contains;
    private:
        std::string color;
        int amount;
};

Node::Node(std::string c, int n)
{
    color = c;
    amount = n;
}

Node::~Node()
{
    for (long unsigned int i = 0; i < contains.size(); i++) {
        if (contains[i] != nullptr) {
            delete contains[i];
        }
    }
}

std::string Node::getColor()
{
    return color;
}

int Node::getAmount()
{
    return amount;
}

void Node::insert(Node *n)
{
    contains.push_back(n);
}

bool contains(std::map<std::string, Node *> m, Node *n, std::string color)
{
    bool aggrgt = false;
    for (long unsigned int i = 0; i < n->contains.size(); i++) {
        if (n->contains[i]->getColor() == color) {
            return true;
        }

        aggrgt = aggrgt || contains(m, m[n->contains[i]->getColor()], color);
    }

    return aggrgt;
}

int combos(std::map<std::string, Node *> m, std::string color)
{
    std::map<std::string, Node *>::iterator it;
    int total = 0;

    for (it = m.begin(); it != m.end(); it++) {
        total += contains(m, it->second, color) ? 1 : 0;
    }

    return total;
}

int inside(std::map<std::string, Node *> m, Node *n)
{
    int total = 0;

    for (unsigned long int i = 0; i < n->contains.size(); i++) {
        int amnt = n->contains[i]->getAmount();
        total += amnt;
        total += amnt * inside(m, m[n->contains[i]->getColor()]);
    }

    return total;
}

int main(void)
{
    std::string line;
    std::map<std::string, Node *> bags;

    while (getline(std::cin, line)) {
        std::stringstream l(line);
        std::string tmp;
        std::string color;
        int amnt = 0;

        l >> tmp;
        while (tmp != "bags") {
            color += tmp;
            l >> tmp;
        }

        Node *n = new Node(color, 1);
        bags.insert(std::make_pair(color, n));
        color.clear();
        l >> tmp;
        while (l >> tmp) {
            if (tmp == "no") {
                break;
            } else if (isdigit(tmp[0])) {
                amnt = atoi(tmp.c_str());
                continue;
            } else if (tmp == "bag," || tmp == "bags," || tmp == "bag." || tmp == "bags.") {
                Node *n2 = new Node(color, amnt);
                n->insert(n2);
                color.clear();
                continue;
            }
            color += tmp;
        }
    }

    std::cout << combos(bags, "shinygold") << std::endl;
    std::cout << inside(bags, bags["shinygold"]) << std::endl;

    for (std::map<std::string, Node *>::iterator it = bags.begin(); it != bags.end(); it++) {
        delete it->second;
    }

    return 0;
}
