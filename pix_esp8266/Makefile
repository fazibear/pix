
BIN = .pio/build/app/program

all: $(BIN)

$(BIN): clean
	platformio run -e app

run: $(BIN)
	./$(BIN) 2> log.txt

upload: clean
	platformio run -e d1_mini -t upload

monitor:
	platformio device monitor -e d1_mini

clean:
	platformio run -t clean
