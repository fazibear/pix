#pragma once

typedef bool PixelData[16][16][3];

class Screen {
public:
  PixelData pixel_data;

  virtual inline PixelData *update() {
    update_state();
    update_pixel_data();
    return &pixel_data;
  };

  virtual inline void update_state(){};
  virtual inline void update_pixel_data(){};
};
