
BIN = .pio/build/app/program

all: $(BIN) run

rm:
	rm -f $(BIN)

$(BIN): rm
	platformio run -e app

run: $(BIN)
	./$(BIN) 2> log.txt

matrix:
	platformio run -e matrix -t upload

matrix_monitor:
	platformio device monitor -e matrix

tft:
	platformio run -e tft -t upload

tft_monitor:
	platformio device monitor -e tft

clean:
	platformio run -t clean

compiledb:
	platformio run -e app -t compiledb
