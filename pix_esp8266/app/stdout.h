#pragma once

#define RST "\x1B[0m"
#define KBLK "\x1B[30m"
#define KRED "\x1B[31m"
#define KGRN "\x1B[32m"
#define KYEL "\x1B[33m"
#define KBLU "\x1B[34m"
#define KMAG "\x1B[35m"
#define KCYN "\x1B[36m"
#define KWHT "\x1B[37m"

#define FBLK(x) KBLK x RST
#define FRED(x) KRED x RST
#define FGRN(x) KGRN x RST
#define FYEL(x) KYEL x RST
#define FBLU(x) KBLU x RST
#define FMAG(x) KMAG x RST
#define FCYN(x) KCYN x RST
#define FWHT(x) KWHT x RST

#define BOLD(x) "\x1B[1m" x RST
#define UNDL(x) "\x1B[4m" x RST
#define CLS "\x1B[2J\x1B[1;1H"

#include "output.h"
#include <cstdint>

class StdOut : public Output {
public:
  void clear();
  void set_dot(uint_fast8_t, uint_fast8_t, bool, bool, bool);
  void draw();

private:
  uint8_t pixel_data[16][16];
  void draw_pixel(char color);
};
