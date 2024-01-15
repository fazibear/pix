#pragma once

#include "platform.h"
#include <chrono>
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
#define CLS "\x1B[2J\x1B[1;1H"

class PC : public Platform {
private:
  CURL *curl;
  uint8_t pixel_data[16][16];
  void draw_pixel(char color);
  std::string fetch(std::string);
  static size_t curl_write_f(char *, size_t, size_t, std::string *);

public:
  void init();
  void clear();
  void set_dot(uint_fast8_t, uint_fast8_t, bool, bool, bool);
  void draw();
};
