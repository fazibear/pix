#include "poo.h"

Poo::Poo(Platform *p) {
  platform = p;
  refresh_every = 60;
  throttle = 10;
  screen_frames = 100;
  refreshed_at = 0;
};

void Poo::refresh() {
  poo_color = rand() % 6 + 1;
  smell_color = rand() % 6 + 1;
};

void Poo::update() {
  frame = !frame;

  for (int sy = 0; sy < POO_HEIGHT; sy++) {
    for (int sx = 0; sx < POO_WIDTH; sx++) {
      platform->set_dot(sx, sy,
                        poo[sy][POO_WIDTH - 1 - sx] ? poo_color : BLACK);
    }
  }

  for (int sy = 0; sy < SMELL_HEIGHT; sy++) {
    for (int sx = 0; sx < SMELL_WIDTH; sx++) {
      platform->set_dot(sx + 1, sy + 1,
                        (frame ? smell_0 : smell_1)[sy][SMELL_WIDTH - 1 - sx]
                            ? smell_color
                            : BLACK);
      platform->set_dot(sx + 13, sy,
                        (frame ? smell_1 : smell_0)[sy][SMELL_WIDTH - 1 - sx]
                            ? smell_color
                            : BLACK);
    }
  }
};
