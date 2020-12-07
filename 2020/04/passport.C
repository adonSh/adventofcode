#include <iostream>
#include <sstream>

const std::string INVALID = "INVALID";

class Passport {
    public:
        Passport();
        bool valid1();
        bool valid2();
        void setByr(int);
        void setIyr(int);
        void setEyr(int);
        void setHgt(std::string);
        void setHcl(std::string);
        void setEcl(std::string);
        void setPid(std::string);
        void setCid(std::string);
        void print();

    private:
        int byr;
        int iyr;
        int eyr;
        std::string hgt;
        std::string hcl;
        std::string ecl;
        std::string pid;
        std::string cid;
};

Passport::Passport(): byr(-1), iyr(-1), eyr(-1), hgt(INVALID), hcl(INVALID), ecl(INVALID), pid(INVALID), cid(INVALID)
{
}

bool verifyHgt(std::string hgt)
{
    if (hgt == INVALID || hgt.size() < 3)
        return false;

    std::string units = hgt.substr(hgt.size()-2, std::string::npos);
    int mag = atoi(hgt.substr(0, hgt.size()-2).c_str());

    if (units == "cm") {
        return (mag > 149 && mag < 194);
    } else if (units == "in") {
        return (mag > 58 && mag < 77);
    }

    return false;
}

bool verifyEcl(std::string ecl)
{
    return (ecl == "amb" ||
            ecl == "blu" ||
            ecl == "brn" ||
            ecl == "gry" ||
            ecl == "grn" ||
            ecl == "hzl" ||
            ecl == "oth");
}

bool verifyHcl(std::string hcl)
{
    if (hcl.size() != 7)
        return false;
    if (hcl[0] != '#')
        return false;

    for (long unsigned int i = 1; i < hcl.size(); i++) {
        if (!isalnum(hcl[i]))
            return false;
    }

    return true;
}

bool verifyPid(std::string pid)
{
    if (pid.size() != 9)
        return false;

    for (long unsigned int i = 0; i < pid.size(); i++) {
        if (!isdigit(pid[i]))
            return false;
    }

    return true;
}

bool Passport::valid1()
{
    return (byr >= 0 && iyr >= 0 && eyr >= 0 && hgt != INVALID && hcl != INVALID && ecl != INVALID && pid != INVALID);
}

bool Passport::valid2()
{
    return ((byr > 1919 && byr < 2003) &&
            (iyr > 2009 && iyr < 2021) &&
            (eyr > 2019 && eyr < 2031) &&
            (verifyHgt(hgt)) &&
            (verifyHcl(hcl)) &&
            (verifyEcl(ecl)) &&
            (verifyPid(pid)));
}

void Passport::setByr(int yr)
{
    byr = yr;
}

void Passport::setIyr(int yr)
{
    iyr = yr;
}

void Passport::setEyr(int yr)
{
    eyr = yr;
}

void Passport::setHgt(std::string h)
{
    hgt = h;
}

void Passport::setHcl(std::string cl)
{
    hcl = cl;
}

void Passport::setEcl(std::string cl)
{
    ecl = cl;
}

void Passport::setPid(std::string id)
{
    pid = id;
}

void Passport::setCid(std::string id)
{
    cid = id;
}

void Passport::print()
{
    std::cout << "byr: ";
    std::cout << byr << std::endl;
    std::cout << "iyr: ";
    std::cout << iyr << std::endl;
    std::cout << "eyr: ";
    std::cout << eyr << std::endl;
    std::cout << "hgt: ";
    std::cout << hgt << std::endl;
    std::cout << "hcl: ";
    std::cout << hcl << std::endl;
    std::cout << "ecl: ";
    std::cout << ecl << std::endl;
    std::cout << "pid: ";
    std::cout << pid << std::endl;
    std::cout << "cid: ";
    std::cout << cid << std::endl;
}

int main(void)
{
    int total1 = 0;
    int total2 = 0;
    std::string l;
    Passport p = Passport();

    while (getline(std::cin, l)) {
        if (l.empty()) {
            total1 = total1 + (p.valid1() ? 1 : 0);
            total2 = total2 + (p.valid2() ? 1 : 0);
            p = Passport();
            continue;
        }
        std::stringstream ss(l);
        std::string thing;

        while (ss >> thing) {
            if (thing.substr(0, 3) == "byr") {
                p.setByr(atoi(thing.substr(4, std::string::npos).c_str()));
            } else if (thing.substr(0, 3) == "iyr") {
                p.setIyr(atoi(thing.substr(4, std::string::npos).c_str()));
            } else if (thing.substr(0, 3) == "eyr") {
                p.setEyr(atoi(thing.substr(4, std::string::npos).c_str()));
            } else if (thing.substr(0, 3) == "hgt") {
                p.setHgt(thing.substr(4, std::string::npos));
            } else if (thing.substr(0, 3) == "hcl") {
                p.setHcl(thing.substr(4, std::string::npos));
            } else if (thing.substr(0, 3) == "ecl") {
                p.setEcl(thing.substr(4, std::string::npos));
            } else if (thing.substr(0, 3) == "pid") {
                p.setPid(thing.substr(4, std::string::npos));
            } else if (thing.substr(0, 3) == "cid") {
                p.setCid(thing.substr(4, std::string::npos));
            }
        }
    }

    total1 = total1 + (p.valid1() ? 1 : 0);
    total2 = total2 + (p.valid2() ? 1 : 0);
    std::cout << total1 << std::endl;
    std::cout << total2 << std::endl;

    return 0;
}
