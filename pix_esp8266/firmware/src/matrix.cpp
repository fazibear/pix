#include "matrix.h"
#include <Arduino.h>

void Matrix::init() {
  pinMode(A1, OUTPUT);
  pinMode(A2, OUTPUT);
  pinMode(A3, OUTPUT);

  pinMode(OE, OUTPUT);
  pinMode(LE, OUTPUT);
  pinMode(SDI, OUTPUT);
  pinMode(CLK, OUTPUT);
}

void Matrix::clear() {
  for (uint8 y = 0; y < LINES; y++) {
    for (uint8 x = 0; x < BITS_PER_LINE; x++) {
      matrix[y][y] = 0;
    }
  }
}
void Matrix::set_dot(uint8 x, uint8 y, bool r, bool g, bool b) {
  if (y % 2) {
    x = x + 16;
  }
  y = (y / 2) - ((y / 2) % 1);

  matrix[y][x] = g;
  matrix[y][x + 32] = b;
  matrix[y][x + 64] = r;
}

void Matrix::set_line(uint8 row) {
  digitalWrite(A1, !(row & 1));
  digitalWrite(A2, !(row & 2));
  digitalWrite(A3, !(row & 4));
}

void Matrix::draw() {
  for (uint8 line = 0; line < LINES; line++) {
    set_line(line);
    digitalWrite(OE, 1);
    for (uint8 bit = 0; bit < BITS_PER_LINE; bit++) {
      digitalWrite(SDI, matrix[line][bit]);
      digitalWrite(CLK, 1);
      digitalWrite(CLK, 0);
    }
    digitalWrite(LE, 1);
    digitalWrite(LE, 0);
    digitalWrite(OE, 0);

    delayMicroseconds(300);
  }

  set_line(0);
  digitalWrite(OE, 1);
}
