CC = g++
CFLAGS = -Wall -g
TEST_SRC = tests/test.cpp
SRC = main.cpp func.cpp
OBJECTS = main.o func.o test.o
TARGET = program

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) -o $(TARGET)

test: $(TEST_SRC) func.o
	$(CC) $(CFLAGS) -I. $(TEST_SRC) func.o -o tests/test_program

clean:
	rm -f $(OBJECTS) $(TARGET) tests/test_program

