#include "CacheContent.h"

CacheContent::CacheContent() {
	this -> val = false;
	this -> tag = 0;
}

void CacheContent::putTag(unsigned int tag) {
	this -> tag = tag;
}


// void CacheContent::putData(unsigned int tag, unsigned int dat) {
// 	this -> tag = tag;
// 	this -> dat = dat;
// }

bool CacheContent::isValid(unsigned int tag) const {
	return this -> val;
}


bool CacheContent::isHit(unsigned int tag) const {
	if (this -> val == false) return false;
	return (tag == (this -> tag));
}