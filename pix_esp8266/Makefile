
BIN = .pio/build/app/program

all: rm $(BIN)

rm:
	rm -f $(BIN)

$(BIN): rm
	platformio run -e app

run: $(BIN)
	./$(BIN) 2> log.txt

upload:
	platformio run -e d1_mini -t upload

monitor:
	platformio device monitor -e d1_mini

clean:
	platformio run -t clean
