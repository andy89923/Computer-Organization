#include "NCache.h"

NCache::NCache() {
}

NCache::NCache(int cache_size, int block_size, int associativity) {
	this -> num = cache_size;
	this -> ass = associativity;
	this -> blo = block_size;

	this -> ofst_bit = (int) log2(block_size);
	this -> indx_bit = (int) log2(cache_size / block_size);
	this -> line = (cache_size >> ofst_bit);

	CacheContent now;
	vector<CacheContent> tmp; tmp.clear();
	for (int i = 0; i < line; i++) {
		tmp.push_back(now);
	}
	for (int i = 0; i < this -> ass; i++) {
		(this -> cache_contents).push_back(tmp);
	}
}

bool NCache::find(unsigned int address) {
	int idx = 0; // which set
	unsigned now_tag = 0;

	for (auto i : (this -> cache_contents[idx])) {
		if (i.isHit(now_tag)) {
			return true;
		}
	}
	return false;
}