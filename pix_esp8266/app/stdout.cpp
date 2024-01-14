#include "stdout.h"
#include <chrono>
#include <iostream>
#include <thread>

using namespace std;

// #define pix "██"
// #define pix "■ "
#define pix "▀ "

void StdOut::init() { cout << CLS; }

void StdOut::clear() {
  for (uint8_t y = 0; y < 16; y++) {
    for (uint8_t x = 0; x < 16; x++) {
      pixel_data[y][x] = 0;
    }
  }
}

void StdOut::set_dot(uint8_t x, uint8_t y, bool r, bool g, bool b) {
  pixel_data[y][x] = b << 2 | g << 1 | r;
}

void StdOut::draw() {
  cout << CLS;
  for (uint8_t y = 0; y < 16; y++) {
    for (uint8_t x = 0; x < 16; x++) {
      draw_pixel(pixel_data[y][x]);
    }
    cout << endl;
  }
  std::this_thread::sleep_for(std::chrono::microseconds(5000));
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
