#include <bits/stdc++.h>
#include <getopt.h>
using namespace std;

#include "NCache.h"

const int K = 1024;

void simulate(int cache_size, int block_size, int asso, string& test_file_name, int list) {
    NCache cache(cache_size, block_size, asso);

    ifstream fin;
    fin.open(test_file_name);

    if (!fin.is_open()) {
        cout << "Error when open files!\n";
        return;
    }

    int ins_cnt = 0;
    vector<int> hit_ins, mis_ins;
    
    hit_ins.clear();
    mis_ins.clear();

    unsigned int now;
    while (fin >> hex >> now) {
        ins_cnt += 1;

        if (cache.find(now, ins_cnt))
            hit_ins.push_back(ins_cnt);
        else
            mis_ins.push_back(ins_cnt);
    }
    fin.close();

    // Output 
    // cout << "Number of instruction(s): ";
    // cout << ins_cnt << '\n';

    int mis_rat = (int) (mis_ins.size() * 100) / ins_cnt;
    cout << "Miss rate: " << mis_rat << "%\n";
    
    if (!list) return;

    cout << "Hits instructions: ";
    for (auto i : hit_ins) cout << i << ' ';
    cout << '\n';
    
    cout << "Misses instructions: ";
    for (auto i : mis_ins) cout << i << ' ';
    cout << '\n';
}

int main(int argc, char** argv) {
	string test_file_name;
	int cache_size = 4;
	int block_size = 16;
	int associativity = 1;
	int current_option;
    int list = 0, misk = 1;

	while ((current_option = getopt(argc, argv, "f:c:b:a:l:k:")) != EOF) {
        switch (current_option) {
            case 'f': {
               test_file_name = string(optarg);
               break;
            }
            case 'c': {
                cache_size = atoi(optarg); 
                break;
            }
            case 'b': {
                block_size = atoi(optarg);
                break;
            }
			case 'a': {
                associativity = atoi(optarg);
                break;
            }
            case 'l': {
                list = atoi(optarg);
                break;
            }
            case 'k': {
                misk = atoi(optarg);
                break;
            }
        }
    }
    if (misk)
        simulate(cache_size * K, block_size, associativity, test_file_name, list);
    else
        simulate(cache_size, block_size, associativity, test_file_name, list);

	return 0;
}