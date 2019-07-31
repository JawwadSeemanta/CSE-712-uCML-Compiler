TARGET  = a.out
GEN_SOURCES = tokens.cpp parser.cpp
GEN_HEADERS = parser.hpp
OUTPUT = uCML.output

LLVMCONFIG = llvm-config
CPPFLAGS = `$(LLVMCONFIG) --cppflags` -std=c++11
LDFLAGS = `$(LLVMCONFIG) --ldflags` -lpthread -ldl -lz -lncurses -rdynamic
LIBS = `$(LLVMCONFIG) --libs`

OBJS = parser.o  \
       codegen.o \
       main.o    \
       tokens.o  \
       corefn.o  \
       native.o  \

FILES = $(TARGET) $(GEN_SOURCES) $(GEN_HEADERS) $(OUTPUT) $(OBJS) parser.cpp parser.hpp parser tokens.cpp

all: clean $(TARGET)

$(TARGET): $(GEN_SOURCES) $(GEN_HEADERS) $(OBJS)
	g++ -g -o $@ $(OBJS) $(LIBS) $(LDFLAGS)

%.o: %.cpp
	g++ -g -c $(CPPFLAGS) -o $@ $<
	
parser.hpp: parser.cpp

parser.cpp: uCML.y
	bison -d -o $@ $^

tokens.cpp: uCML.l parser.hpp
	flex -o $@ $^

clean:
	rm -f $(FILES)
	
test: a.out example.txt
	cat example.txt | ./a.out
