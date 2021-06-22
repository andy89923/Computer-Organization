#ifndef NCache_H_INCLUDE
#define NCache_H_INCLUDE

#include <vector>
#include <cmath>
using namespace std;

#include "CacheContent.h"

class NCache {
private:
	int ass, blo, num;
	vector<vector<CacheContent> > cache_contents;

	int ofst_bit;
	int indx_bit;
	int line;

public:
	NCache();
	NCache(int, int, int);
	
	bool find(unsigned int);
};

#endif