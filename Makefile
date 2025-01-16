CXX = g++
CXXFLAGS = -Wall -std=c++11
TARGET = func

all: $(TARGET)

$(TARGET): main.o func.o
	$(CXX) $(CXXFLAGS) -o $(TARGET) main.o func.o

main.o: main.cpp func.h
	$(CXX) $(CXXFLAGS) -c main.cpp

funcA.o: funcA.cpp funcA.h
	$(CXX) $(CXXFLAGS) -c func.cpp

clean:
	rm -f *.o $(TARGET)
