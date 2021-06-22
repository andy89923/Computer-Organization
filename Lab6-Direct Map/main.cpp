#include <bits/stdc++.h>
#include <getopt.h>
using namespace std;

#include "NCache.h"

const int K = 1024;

void simulate(int cache_size, int block_size, int asso, string& test_file_name) {
    NCache cache(cache_size, block_size, asso);



}

int main(int argc, char** argv) {
	string test_file_name;
	int cache_size = 4;
	int block_size = 16;
	int associativity = 1;
	int current_option;

	while ((current_option = getopt(argc, argv, "f:c:b:a:")) != EOF) {
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
        }
    }
    simulate(cache_size * K, block_size, associativity, test_file_name);

	return 0;
}