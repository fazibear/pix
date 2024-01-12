#pragma once

#include <cstdint>

#define A1 0
#define A2 4
#define A3 5

#define OE 14
#define LE 12
#define SDI 13
#define CLK 15

#define LINES 8
#define PER_LINE 12

class Output {
public:
  Output();
  ~Output();

  void clean();
  void set_dot(uint_fast8_t x, uint_fast8_t y, uint_fast8_t r, uint_fast8_t g,
               uint_fast8_t b);
  void draw();
};
