
BIN = .pio/build/app/program

all: clean $(BIN)

$(BIN): $(wildcard src/**/*) $(wildcard lib/**/*)
	platformio run -e app

run: $(BIN)
	./$(BIN)

upload:  clean
	platformio run -e d1_mini -t upload

clean:
	platformio run -t clean
