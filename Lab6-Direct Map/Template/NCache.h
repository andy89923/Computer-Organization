#ifndef NCache_H_INCLUDE
#define NCache_H_INCLUDE

#include <vector>
#include <cmath>
using namespace std;

#include "CacheContent.h"

class NCache {
private:
	int ass, blo, siz;
	vector<vector<CacheContent> > cache_contents;

	int ofst_bit;
	int indx_bit;
	int asso_bit;
	int line;

public:
	NCache();
	NCache(int, int, int);
	
	void missHandle(unsigned int, int);
	bool find(unsigned int, int);
};

#endif