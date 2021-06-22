#ifndef CacheContent_H_INCLUDE
#define CacheContent_H_INCLUDE

class CacheContent{

private:
	bool val;
	unsigned int tag;
	// unsigned int dat[16];

public:
	CacheContent();

	// void putData(unsigned int, unsigned int);
	void putTag(unsigned int);


	bool isValid(unsigned int) const;
	bool isHit(unsigned int) const;
	// unsigned int getData() const;
};

#endif