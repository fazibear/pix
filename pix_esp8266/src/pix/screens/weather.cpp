#include "weather.h"
#include "chars.h"

Weather::Weather(Platform *p) {
  platform = p;
  throttle = 10;
  refresh_every = 60 * 60;
  screen_frames = 100;
  frame = false;
  refreshed_at = 0;
};

void Weather::refresh() {
  std::string data =
      platform->fetch("https://api.openweathermap.org/data/2.5/"
                      "weather?q=Warsaw&units=metric&appid=" OWM_KEY);

  if (data != "error") {
    auto icon_at = data.find("\"icon\"");
    auto temp_at = data.find("\"temp\"");

    icon = data.substr(icon_at + 8, 2);
    day = data.substr(icon_at + 10, 1) == "d";
    temp = data.substr(temp_at + 7, 4);

    auto temp_dot = temp.find(".");
    if (temp_dot != std::string::npos) {
      temp = temp.substr(0, temp_dot);
    }

    auto temp_q = temp.find("\"");
    if (temp_q != std::string::npos) {
      temp = temp.substr(0, temp_q);
    }

    temp = "    " + temp;
  } else {
    icon = "01";
    day = true;
    temp = " err";
  }
};

void Weather::update() {
  frame = !frame;

  platform->clear();

  auto sun_or_moon = day ? (frame ? sun_0 : sun_1) : (frame ? moon_0 : moon_1);

  if (icon == "01" || icon == "02" || icon == "10") {
    for (size_t y = 0; y < 8; y++) {
      for (size_t x = 0; x < 8; x++) {
        if (sun_or_moon[y][7 - x]) {
          platform->set_dot(x + 8, y, day ? YELLOW : WHITE);
        }
      }
    }
  }

  if (icon == "04" || icon == "09" || icon == "11") {
    for (size_t y = 0; y < 7; y++) {
      for (size_t x = 0; x < 10; x++) {
        if (cloud[y][9 - x]) {
          platform->set_dot(x + 6, y + 1, BLUE);
        }
      }
    }
  }

  if (icon == "02" || icon == "03" || icon == "04" || icon == "09" ||
      icon == "10" || icon == "11" || icon == "13") {
    for (size_t y = 0; y < 7; y++) {
      for (size_t x = 0; x < 10; x++) {
        if (cloud[y][9 - x]) {
          platform->set_dot(x, y, WHITE);
        }
      }
    }
  }

  if (icon == "09" || icon == "10") {
    for (size_t y = 0; y < 6; y++) {
      for (size_t x = 0; x < 8; x++) {
        if ((frame ? rain_0 : rain_1)[y][x]) {
          platform->set_dot(x + 1, y + 6, BLUE);
        }
      }
    }
  }

  if (icon == "11") {
    for (size_t y = 0; y < 5; y++) {
      for (size_t x = 0; x < 6; x++) {
        if (thunder[y][x]) {
          platform->set_dot(x + 2, y + 6, RED);
        }
      }
    }
  }

  if (icon == "13") {
    for (size_t y = 0; y < 4; y++) {
      for (size_t x = 0; x < 8; x++) {
        if ((frame ? snow_0 : snow_1)[y][x]) {
          platform->set_dot(x + 3, y + 6, WHITE);
        }
      }
    }
  }

  if (icon == "50") {
    for (size_t y = 0; y < 8; y++) {
      for (size_t x = 0; x < 16; x++) {
        if (mist[y][x]) {
          platform->set_dot(x, y, WHITE);
        }
      }
    }
  }

  int temp_len = temp.length() - 4;
  for (int i = 0; i < 4; i++) {
    Chars::put_char(platform, temp[temp_len + i], i * 4 + 1, 9, GREEN);
  }
};
