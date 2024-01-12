#include "stdout.h"
#include <chrono>
#include <iostream>
#include <thread>

using namespace std;

// #define pix "██"
// #define pix "■ "
#define pix "▀ "

void StdOut::clear() {
  for (uint_fast8_t x = 0; x < 16; x++) {
    for (uint_fast8_t y = 0; y < 16; y++) {
      pixel_data[x][y] = 0;
    }
  }
}

void StdOut::set_dot(uint_fast8_t x, uint_fast8_t y, uint_fast8_t r,
                     uint_fast8_t g, uint_fast8_t b) {

  pixel_data[x][y] = r << 2 | g << 1 | b;
}

void StdOut::draw() {
  cout << CLS;
  for (uint_fast8_t y = 0; y < 16; y++) {
    for (uint_fast8_t x = 0; x < 16; x++) {
      draw_pixel(pixel_data[x][y]);
    }
    cout << endl;
  }
  std::this_thread::sleep_for(std::chrono::milliseconds(200));
}

void StdOut::draw_pixel(char color) {
  switch (color) {
  case 1:
    cout << FRED(pix);
    break;
  case 2:
    cout << FGRN(pix);
    break;
  case 3:
    cout << FYEL(pix);
    break;
  case 4:
    cout << FBLU(pix);
    break;
  case 5:
    cout << FMAG(pix);
    break;
  case 6:
    cout << FCYN(pix);
    break;
  case 7:
    cout << FWHT(pix);
    break;
  default:
    cout << FBLK(pix);
    break;
  }
}
