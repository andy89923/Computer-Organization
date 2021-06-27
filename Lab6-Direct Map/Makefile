cache_simulator: main.cpp $(shell find Template/ -type f)
	g++-7 -std=c++11 -o cache_simulator -I Template/ *.cpp

clean:
	rm cache_simulator


all: cache_simulator

run: cache_simulator
	./cache_simulator -f Trace1.txt -c 1 -b 32 -a 2 -l 1