#include "screens/crab.h"

void Crab::update_state() {
  if (x <= 0 or x >= 16 - CRAB_WIDTH) {
    dir_x = !dir_x;
    // randomize color
  }
  dir_x ? x++ : x--;

  if (y <= 0 or y >= 16 - CRAB_HEIGHT) {
    dir_y = !dir_y;
    // randomize color
  }
  dir_y ? y++ : y--;
};

void Crab::update_pixel_data(){

};
