#pragma once

#include "screen.h"
#include <bitset>
#include <cstdint>

#define POO_HEIGHT 16
#define POO_WIDTH 16

#define SMELL_HEIGHT 6
#define SMELL_WIDTH 2

using namespace std;

class Poo : public Screen {
private:
  char poo_color;
  char smell_color_0;
  char smell_color_1;
  bool frame;
  Platform *platform;
  bitset<POO_WIDTH> const poo[POO_HEIGHT]{
      bitset<POO_WIDTH>("000000000000000"), //
      bitset<POO_WIDTH>("000000010000000"), //
      bitset<POO_WIDTH>("000000110000000"), //
      bitset<POO_WIDTH>("000000111000000"), //
      bitset<POO_WIDTH>("000001111100000"), //
      bitset<POO_WIDTH>("000011111100000"), //
      bitset<POO_WIDTH>("000001111101000"), //
      bitset<POO_WIDTH>("000111111111100"), //
      bitset<POO_WIDTH>("001111111111100"), //
      bitset<POO_WIDTH>("001110110111000"), //
      bitset<POO_WIDTH>("000111111111110"), //
      bitset<POO_WIDTH>("011111111111111"), //
      bitset<POO_WIDTH>("111101111011111"), //
      bitset<POO_WIDTH>("111110000111111"), //
      bitset<POO_WIDTH>("011111111111110"), //
      bitset<POO_WIDTH>("000111111111000")  //
  };
  bitset<SMELL_WIDTH> const smell_0[SMELL_HEIGHT]{
      bitset<SMELL_WIDTH>("10"), //
      bitset<SMELL_WIDTH>("10"), //
      bitset<SMELL_WIDTH>("10"), //
      bitset<SMELL_WIDTH>("01"), //
      bitset<SMELL_WIDTH>("01"), //
      bitset<SMELL_WIDTH>("10"), //
  };

  bitset<SMELL_WIDTH> const smell_1[SMELL_HEIGHT]{
      bitset<SMELL_WIDTH>("01"), //
      bitset<SMELL_WIDTH>("01"), //
      bitset<SMELL_WIDTH>("01"), //
      bitset<SMELL_WIDTH>("10"), //
      bitset<SMELL_WIDTH>("10"), //
      bitset<SMELL_WIDTH>("01"), //
  };

public:
  Poo(Platform *p);
  ~Poo();
  void update();
  void refresh();
};
