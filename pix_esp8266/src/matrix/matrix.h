#pragma once

#include "platform.h"
#include <Arduino.h>
#include <ESP8266HTTPClient.h>
#include <ESP8266WiFi.h>
#include <NTPClient.h>
#include <Timezone.h>
#include <WifiUdp.h>
#include <bitset>

#define TIME_SERVER "pool.ntp.org"
#define TIME_REFRESH 24 * 60 * 60 * 1000

#define A1 0
#define A2 4
#define A3 5

#define OE 14
#define LE 12
#define SDI 13
#define CLK 15

#define BTN1 16
#define BTN2 2
#define BTN3 1
#define BTN4 3

#define LINES 8
// #define PER_LINE 12
#define BITS_PER_LINE 16 * 2 * 3

class Matrix : public Platform {
public:
  Matrix();
  void clear();
  void set_dot(uint8, uint8, uint8);
  void draw();

  int8_t read_buttons();

  time_t get_time();
  Time get_datetime();
  std::string fetch(std::string);
  void debug(std::string, ...);

private:
  void set_line(uint8 row);
  std::bitset<BITS_PER_LINE> matrix[LINES] = {{0}};
  WiFiUDP *udp;
  NTPClient *time;
  Timezone *tz;
  bool button_pressed = false;
};
