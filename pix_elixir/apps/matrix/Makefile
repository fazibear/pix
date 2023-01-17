CFLAGS = -g -I$(ERL_EI_INCLUDE_DIR)
LDFLAGS = -L$(ERL_EI_LIBDIR) -lei -lpthread -lrt

PREFIX = $(MIX_APP_PATH)/priv
BUILD  = $(MIX_APP_PATH)/obj

BUILD_DIRS = $(PREFIX) $(BUILD) $(BUILD)/src $(BUILD)/src/lib

SRC = $(wildcard src/*.c src/lib/*.c)
OBJ = $(SRC:%.c=$(BUILD)/%.o)

MATRIX = $(PREFIX)/matrix

$(MATRIX): $(BUILD_DIRS) $(OBJ)
	$(CC) -o $@ $(OBJ) $(LDFLAGS)

$(BUILD)/src/%.o: src/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(BUILD_DIRS):
	mkdir -p $@

clean:
	rm -rf $(MATRIX) $(OBJ) $(BUILD_DIRS)
