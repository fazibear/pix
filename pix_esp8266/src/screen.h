#pragma once

typedef bool PixelData[16][16][3];

class Screen {
public:
  Screen();
  ~Screen();
  PixelData *update();
  PixelData pixel_data = {{{0}}};
  void update_state();
  void update_pixel_data();
};
