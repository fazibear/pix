#include "screen.h"

PixelData *Screen::update() {
  update_state();
  update_pixel_data();
  return &pixel_data;
};

void Screen::update_state(){
    // Override this method in your screen class
};

void Screen::update_pixel_data(){
    // Override this method in your screen class
};
