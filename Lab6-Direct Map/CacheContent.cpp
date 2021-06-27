#include "CacheContent.h"

CacheContent::CacheContent() {
	this -> val = false;
	this -> tag = 0;
	this -> use_tim = -1;
}

void CacheContent::putTag(unsigned int tag, int tim) {
	this -> tag = tag;
	this -> val = true;
	this -> use_tim = tim;
}

// void CacheContent::putData(unsigned int tag, unsigned int dat) {
// 	this -> tag = tag;
// 	this -> dat = dat;
// }

bool CacheContent::isValid() const {
	return this -> val;
}


bool CacheContent::isHit(unsigned int tag, int tim) {
	if (this -> val == false) return false;

	if (this -> tag == tag) {
		this -> use_tim = tim;
		return true;
	}
	return false;
}

int CacheContent::getTime() const {
	return this -> use_tim; 
}