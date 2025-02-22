TARGET  = a.out
GEN_SOURCES = tokens.cpp parser.cpp
GEN_HEADERS = parser.hpp
OUTPUT = uCML.output

LLVMCONFIG = llvm-config
CPPFLAGS = `$(LLVMCONFIG) --cppflags` -std=c++11
LDFLAGS = `$(LLVMCONFIG) --ldflags` -rdynamic
LIBS = `$(LLVMCONFIG) --libs`

OBJS = parser.o  \
       CodeGeneration.o \
       Main.o    \
       tokens.o  \
       ExternalPrintFunction.o  \
       PrintFunctionCore.o  \

FILES = $(TARGET) $(GEN_SOURCES) $(GEN_HEADERS) $(OUTPUT) $(OBJS)

all: clean $(TARGET)

$(TARGET): $(GEN_SOURCES) $(GEN_HEADERS) $(OBJS)
	g++ -g -o $@ $(OBJS) $(LIBS) $(LDFLAGS)

%.o: %.cpp
	g++ -g -O3 -c $(CPPFLAGS) -o $@ $<
	
parser.hpp: parser.cpp

parser.cpp: uCML.y
	bison -d -o $@ $^

tokens.cpp: uCML.l parser.hpp
	flex -o $@ $^

clean:
	rm -rf $(FILES) output
	
test: a.out run.sh
	sh run.sh
