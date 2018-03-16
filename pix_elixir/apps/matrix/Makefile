ERL_PATH = $(shell erl -eval "io:format(\"~s~n\", [code:root_dir()])" -s init stop -noshell)
ERL_EI_INCLUDE_DIR ?= $(ERL_PATH)/usr/include
ERL_EI_LIBDIR ?= $(ERL_PATH)/usr/lib

CFLAGS = -g -I$(ERL_EI_INCLUDE_DIR)
LDFLAGS = -L$(ERL_EI_LIBDIR) -lerl_interface -lei -lpthread -lrt

HEADER_FILES = src/lib

SRC = $(wildcard src/*.c src/lib/*.c)
OBJ = $(SRC:.c=.o)

priv/matrix: priv $(OBJ)
	$(CC) -I $(HEADER_FILES) -o $@ $(OBJ) $(LDLIBS) $(LDFLAGS)

priv:
	mkdir -p priv

clean:
	rm -rf priv $(OBJ) $(LIB_OBJ) $(BEAM_FILES)
