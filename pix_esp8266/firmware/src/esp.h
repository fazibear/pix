#pragma once

#include "Arduino.h"
#include "platform.h"
#include <Arduino.h>
#include <ESP8266HTTPClient.h>
#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <NTPClient.h>
#include <WiFiClient.h>
#include <WiFiClientSecureBearSSL.h>
#include <WifiUdp.h>
#include <Wire.h>
#include <bitset>
#include <string>

#define A1 0
#define A2 4
#define A3 5

#define OE 14
#define LE 12
#define SDI 13
#define CLK 15

#define LINES 8
// #define PER_LINE 12
#define BITS_PER_LINE 16 * 2 * 3

class Esp : public Platform {
public:
  void init();
  void clear();
  void set_dot(uint8, uint8, uint8);
  void draw();

  time_t get_time();
  Time get_datetime();
  std::string fetch(std::string);
  void debug(std::string, ...);

private:
  void set_line(uint8 row);
  std::bitset<BITS_PER_LINE> matrix[LINES] = {{0}};
  std::string time_server = "time.nist.gov";
  WiFiUDP *udp;
  NTPClient *time;
};
