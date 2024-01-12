#pragma once

typedef bool PixelData[16][16][3];

class Screen {
public:
  PixelData pixel_data = {{{0}}};

  Screen();
  ~Screen();

  virtual PixelData *update();
  virtual void update_state();
  virtual void update_pixel_data();
};
