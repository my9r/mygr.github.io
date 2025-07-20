#include "coins.h"

int solve(std::vector<int> a) {
    if (a.size() == 1) {
        return 0;
    }
    
    std::vector<int> p(a.size());
    p[0] = 1;
    if (weigh(p) == 6) {
        return 0;
    } else {
        return 1;
    }
}