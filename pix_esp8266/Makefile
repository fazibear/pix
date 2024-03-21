
BIN = .pio/build/app/program

all: $(BIN) run

$(BIN): $(wildcard src/**/*) $(wildcard lib/**/*)
	platformio run -e app

run: $(BIN)
	./$(BIN)

upload:
	platformio run -e d1_mini -t upload

clean:
	platformio run -t clean
