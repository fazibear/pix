#include "matrix.h"
#include <Arduino.h>

Matrix::Matrix() {
  pinMode(A1, OUTPUT);
  pinMode(A2, OUTPUT);
  pinMode(A3, OUTPUT);

  pinMode(OE, OUTPUT);
  pinMode(LE, OUTPUT);
  pinMode(SDI, OUTPUT);
  pinMode(CLK, OUTPUT);
}

void Matrix::clear() {
  for (uint_fast8_t y = 0; y < LINES; y++) {
    for (uint_fast8_t x = 0; x < PER_LINE; x++) {
      matrix[y][x] = 255;
    }
  }
}

void Matrix::set_dot(uint_fast8_t x, uint_fast8_t y, bool r, bool g, bool b) {
  uint_fast8_t l, p, t;

  if (y % 2) {
    x = (x + 16);
  }
  y = (y / 2) - ((y / 2) % 1);

  l = x / 8;
  p = 7 - x % 8;
  t = matrix[y][l];

  if (g) {
    t |= 1 << p;
  } else {
    t &= ~(1 << p);
  }
  matrix[y][l] = t;

  l = x / 8 + 4;
  p = 7 - x % 8;
  t = matrix[y][l];
  if (b) {
    t |= 1 << p;
  } else {
    t &= ~(1 << p);
  }
  matrix[y][l] = t;

  l = x / 8 + 8;
  p = 7 - x % 8;
  t = matrix[y][l];
  if (r) {
    t |= 1 << p;
  } else {
    t &= ~(1 << p);
  }
  matrix[y][l] = t;
}

void Matrix::set_line(uint_fast8_t row) {
  digitalWrite(A1, !(row & 0b00000001));
  digitalWrite(A2, !(row & 0b00000010));
  digitalWrite(A3, !(row & 0b00000100));
}

void Matrix::draw() {
  for (uint_fast8_t line = 0; line < LINES; line++) {
    set_line(line);
    digitalWrite(OE, 1);
    for (uint_fast8_t pos = 0; pos < PER_LINE; pos++) {
      for (uint_fast8_t bit = 0; bit < 8; bit++) {
        digitalWrite(SDI, !!(matrix[line][pos] & (1 << (7 - bit))));
        digitalWrite(CLK, 1);
        digitalWrite(CLK, 0);
      }
    }
    digitalWrite(LE, 1);
    digitalWrite(LE, 0);
    digitalWrite(OE, 0);
  }
  delayMicroseconds(100);
}
