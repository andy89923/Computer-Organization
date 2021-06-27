cache_simulator: main.cpp $(shell find Template/ -type f)
	g++ -std=c++11 -o cache_simulator -I Template/ *.cpp

clean:
	rm cache_simulator

all: clean cache_simulator run

run: cache_simulator
	./cache_simulator -f Trace1.txt -c 1 -b 32 -a 2 -l 1
	./cache_simulator -f Trace.txt  -c 4 -a 1 -b 16  -l 0

plot: cache_simulator plot.py
	python3 plot.py
