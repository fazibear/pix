#include "matrix.h"

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
  for (uint8 y = 0; y < LINES; y++) {
    for (uint8 x = 0; x < BITS_PER_LINE; x++) {
      matrix[y][x] = 0;
    }
  }
}
void Matrix::set_dot(uint8 x, uint8 y, bool r, bool g, bool b) {
  if (y % 2) {
    x += 48;
  }
  y = (y / 2) - ((y / 2) % 1);

  matrix[y][x] = g;
  matrix[y][x + 16] = b;
  matrix[y][x + 32] = r;
}

// void Matrix::set_dot_old(uint8 x, uint8 y, bool r, bool g,
//                          bool b) {
//   uint8 l, p, t;
//
//   if (y % 2) {
//     x = (x + 16);
//   }
//   y = (y / 2) - ((y / 2) % 1);
//
//   l = x / 8;
//   p = 7 - x % 8;
//   t = matrix[y][l];
//
//   if (g) {
//     t |= 1 << p;
//   } else {
//     t &= ~(1 << p);
//   }
//   matrix[y][l] = t;
//
//   l = x / 8 + 4;
//   p = 7 - x % 8;
//   t = matrix[y][l];
//   if (b) {
//     t |= 1 << p;
//   } else {
//     t &= ~(1 << p);
//   }
//   matrix[y][l] = t;
//
//   l = x / 8 + 8;
//   p = 7 - x % 8;
//   t = matrix[y][l];
//   if (r) {
//     t |= 1 << p;
//   } else {
//     t &= ~(1 << p);
//   }
//   matrix[y][l] = t;
// }

void Matrix::set_line(uint8 row) {
  digitalWrite(A1, !(row & 0b00000001));
  digitalWrite(A2, !(row & 0b00000010));
  digitalWrite(A3, !(row & 0b00000100));
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
