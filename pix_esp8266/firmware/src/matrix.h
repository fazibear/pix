#pragma once

#include "output.h"
#include <Arduino.h>
#include <bitset>

#define A1 0
#define A2 4
#define A3 5

#define OE 14
#define LE 12
#define SDI 13
#define CLK 15

#define LINES 8
// #define PER_LINE 12
#define BITS_PER_LINE 16 * 2 * 3

class Matrix : public Output {
public:
  void init();
  void clear();
  void set_dot(uint8 x, uint8 y, bool r, bool g, bool b);
  void draw();

private:
  void set_line(uint8 row);
  std::bitset<BITS_PER_LINE> matrix[LINES] = {{0}};
  // uint8 matrix[LINES][PER_LINE] = {{0}};
};
