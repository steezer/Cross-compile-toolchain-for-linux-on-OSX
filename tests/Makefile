CROSS_ROOT=/Develop/vendor/toolchain/x86_64-mac-linux-gnu
CXX=$(CROSS_ROOT)/bin/x86_64-linux-g++
CC=$(CROSS_ROOT)/bin/x86_64-linux-gcc

CFLAGS=-g -O2
LDFLAGS=-lm

TARGET=build/app
all: clean $(TARGET)

%/app: %/app.o %/test.o
	$(CXX) -o $@ $^ $(LDFLAGS)

build/%.o: src/%.cpp
	[ -d build ] || mkdir build
	$(CXX) $(CFLAGS) -c -o $@ $^ 

build/%.o: src/%.c
	$(CC) $(CFLAGS) -c -o $@ $^

clean:
	@rm -f $(TARGET) build/*.o
