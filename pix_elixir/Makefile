ERL_PATH = $(shell erl -eval "io:format(\"~s~n\", [code:root_dir()])" -s init stop -noshell)
ERL_PATH_INC = $(ERL_PATH)/usr/include
ERL_PATH_LIB = $(ERL_PATH)/usr/lib

CFLAGS = -g -I$(ERL_PATH_INC)
LDFLAGS = -L$(ERL_PATH_LIB) -lerl_interface -lei -lerts -lpthread

HEADER_FILES = src

SRC = $(wildcard src/*.c src/**/*.c)

OBJ = $(SRC:.c=.o)

DEFAULT_TARGETS ?= priv priv/matrix

priv/matrix: priv $(OBJ)
	$(CC) -I $(HEADER_FILES) -o $@ $(OBJ) $(LDLIBS) $(LDFLAGS)

priv:
	mkdir -p priv

clean:
	rm -rf priv $(OBJ) $(BEAM_FILES)
