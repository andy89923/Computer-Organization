#ifndef CacheContent_H_INCLUDE
#define CacheContent_H_INCLUDE

class CacheContent{

private:
	bool val;
	unsigned int tag;
	int use_tim;
	// unsigned int dat[16];

public:
	CacheContent();

	// void putData(unsigned int, unsigned int);
	void putTag(unsigned int, int);


	bool isValid() const;
	bool isHit(unsigned int, int);
	int getTime() const;
	// unsigned int getData() const;
};

#endif