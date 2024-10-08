#pragma once

#include "pix.h"
#include "platform.h"
#include "time.h"
#include <array>
#include <chrono>
#include <ctime>
#include <curl/curl.h>
#include <iostream>
#include <thread>

// #define pixel "██"
// #define pixel "■ "
#define pixel "▀ "

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
#define CLS "\x1B[2J"
#define HOME "\x1B[1H"

class PC : public Platform {
public:
  PC();
  void clear();
  void set_dot(uint8_t, uint8_t, uint8_t);
  void draw();

  int8_t read_buttons();

  std::string fetch(std::string);

  time_t get_time();
  Time get_datetime();
  void debug(std::string, ...);

private:
  CURL *curl;
  uint8_t pixel_data[16][16];
  void draw_pixel(char color);
  static size_t curl_write_f(char *, size_t, size_t, std::string *);
};
