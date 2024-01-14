#pragma once

#include "../screen.h"
#include <cstdint>

#define CRAB_HEIGHT 8
#define CRAB_WIDTH 11

using namespace std;

class Crab : public Screen {
private:
  int x;
  int y;
  bool dir_x;
  bool dir_y;
  char color;
  bool frame;
  uint8_t frame_counter;
  bitset<CRAB_WIDTH> const crab_0[CRAB_HEIGHT]{
      bitset<CRAB_WIDTH>("00100000100"), // '  1     1  ',
      bitset<CRAB_WIDTH>("10010001001"), // '1  1   1  1',
      bitset<CRAB_WIDTH>("10111111101"), // '1 1111111 1',
      bitset<CRAB_WIDTH>("11101110111"), // '111 111 111',
      bitset<CRAB_WIDTH>("11111111111"), // '11111111111',
      bitset<CRAB_WIDTH>("01111111110"), // ' 111111111 ',
      bitset<CRAB_WIDTH>("00100000100"), // '  1     1  ',
      bitset<CRAB_WIDTH>("01000000010")  // ' 1       1 '
  };
  bitset<CRAB_WIDTH> const crab_1[CRAB_HEIGHT]{
      bitset<CRAB_WIDTH>("00100000100"), // '  1     1  ',
      bitset<CRAB_WIDTH>("00010001000"), // '   1   1   ',
      bitset<CRAB_WIDTH>("00111111100"), // '  1111111  ',
      bitset<CRAB_WIDTH>("01101110110"), // ' 11 111 11 ',
      bitset<CRAB_WIDTH>("11111111111"), // '11111111111',
      bitset<CRAB_WIDTH>("10111111101"), // '1 1111111 1',
      bitset<CRAB_WIDTH>("10100000101"), // '1 1     1 1',
      bitset<CRAB_WIDTH>("00011011000")  // '   11 11   '
  };

public:
  Crab();
  ~Crab();
  PixelData *update();
};
