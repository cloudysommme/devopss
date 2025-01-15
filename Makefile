CXX = g++
CXXFLAGS = -std=c++11 -Wall
SOURCES = main.cpp func.cpp
OBJECTS = $(SOURCES:.cpp=.o)
EXEC = main

all: $(EXEC)

$(EXEC): $(OBJECTS)
    $(CXX) $(CXXFLAGS) -o $(EXEC) $(OBJECTS)

.cpp.o:
    $(CXX) $(CXXFLAGS) -c $<

clean:
    rm -f $(OBJECTS) $(EXEC)
