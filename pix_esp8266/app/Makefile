CC = clang++

BIN = pix

PIX_LIB = ../pix

PIX_SRC = $(shell find $(PIX_LIB) -name "*.cpp")
APP_SRC = $(shell find . -name "*.cpp")

INC_DIRS = . $(PIX_LIB) $(PIX_LIB)/screens
INCLUDES = $(foreach d, $(INC_DIRS), -I$d)

SRC = $(APP_SRC) $(PIX_SRC)
OBJ = $(SRC:.cpp=.o)

CFLAGS = -std=gnu++20 -g -Wextra -Wall -Wcpp $(INCLUDES)
LDFLAGS = -lcurl

all: clean $(BIN) run

%.o: %.cpp
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

$(BIN): $(OBJ)
	$(CC) $(LDFLAGS) $^ -o $(BIN)

.PHONY: clean

run: $(BIN)
	./$(BIN) 2> log

clean:
	rm -f $(OBJ) $(BIN)
