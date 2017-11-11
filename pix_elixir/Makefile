ERL_PATH = $(shell erl -eval "io:format(\"~s~n\", [code:root_dir()])" -s init stop -noshell)
ERL_PATH_INC = $(ERL_PATH)/usr/include
ERL_PATH_LIB = $(ERL_PATH)/usr/lib

CFLAGS = -g -I$(ERL_PATH_INC)
LDFLAGS = -L$(ERL_PATH_LIB) -lerl_interface -lei -lerts -lpthread

HEADER_FILES = src/lib

SRC = $(wildcard src/*.c)
OBJ = $(SRC:.c=.o)

LIB_SRC = $(wildcard src/lib/*.c)
LIB_OBJ = $(LIB_SRC:.c=.o)

all: priv/matrix priv/sysfs

priv/matrix: priv src/matrix.o $(LIB_OBJ)
	$(CC) -I $(HEADER_FILES) -o $@ src/matrix.o $(LIB_OBJ) $(LDLIBS) $(LDFLAGS)

priv/sysfs: priv src/sysfs.o $(LIB_OBJ)
	$(CC) -I $(HEADER_FILES) -o $@ src/sysfs.o $(LIB_OBJ) $(LDLIBS) $(LDFLAGS)

priv:
	mkdir -p priv

clean:
	rm -rf priv $(OBJ) $(LIB_OBJ) $(BEAM_FILES)
