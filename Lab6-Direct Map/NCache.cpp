#include "NCache.h"

NCache::NCache() {
}

NCache::NCache(int cache_size, int block_size, int associativity) {
	this -> siz = cache_size;
	this -> ass = associativity;
	this -> blo = block_size;

	this -> asso_bit = (int) log2(associativity);
	this -> ofst_bit = (int) log2(block_size);
	this -> indx_bit = (int) log2(cache_size / block_size);
	this -> line = (cache_size >> ofst_bit);

	CacheContent now;
	vector<CacheContent> tmp; tmp.clear();
	for (int i = 0; i < associativity; i++) {
		tmp.push_back(now);
	}
	for (int i = 0; i < line; i++) {
		(this -> cache_contents).push_back(tmp);
	}
}

void NCache::missHandle(unsigned int a, int tim) {
	int idx = (a >> this -> ofst_bit) & ((1 << (this -> indx_bit - this -> asso_bit)) - 1);
	unsigned now_tag = (a >> (this -> indx_bit + this -> ofst_bit));

	int min_pos = 0, min_tim = -1, cnt = 0;
	for (auto &i : (this -> cache_contents[idx])) {
		if (!i.isValid()) {
			i.putTag(now_tag, tim);
			return;
		}
		int now_tim = i.getTime();
		if (min_tim < now_tim) {
			min_tim = now_tim;
			min_pos = cnt;
		}
		cnt += 1;
	}

	this -> cache_contents[idx][min_pos].putTag(now_tag, tim);
}


bool NCache::find(unsigned int a, int tim) {
	int idx = (a >> this -> ofst_bit) & ((1 << (this -> indx_bit - this -> asso_bit)) - 1);
	unsigned now_tag = (a >> (this -> indx_bit + this -> ofst_bit));

	for (auto i : (this -> cache_contents[idx])) {
		if (i.isHit(now_tag, tim)) {
			return true;
		}
	}
	this -> missHandle(a, tim);

	return false;
}