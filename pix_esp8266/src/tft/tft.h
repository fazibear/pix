#pragma once

#include "platform.h"
#include <Arduino.h>
#include <ESP8266HTTPClient.h>
#include <ESP8266WiFi.h>
#include <NTPClient.h>
#include <TFT_eSPI.h>
#include <WiFiClient.h>
#include <WiFiServer.h>
#include <string>

#include <ArduinoOTA.h>

#define TIME_SERVER "pool.ntp.org"
#define TIME_REFRESH 24 * 60 * 60 * 1000
#define TIME_OFFSET_WINTER 3600
#define TIME_OFFSET_SUMMER 7200

#define TFT_CLK 14
#define TFT_MOSI 13
#define TFT_DC 0
#define TFT_RST 2
#define TFT_CS 15
#define TFT_BACKLIGHT 5

class TFT : public Platform {
public:
  TFT();
  void clear();
  void set_dot(uint8, uint8, uint8);
  void draw();

  int8_t read_buttons();

  time_t get_time();
  Time get_datetime();
  std::string fetch(std::string);
  void debug(std::string, ...);

private:
  WiFiUDP *udp;
  NTPClient *time;
  TFT_eSPI *tft;
  bool button_pressed = false;
  void setup_ota();
  void setup_tft();
  void setup_wifi();
  void setup_time();
};
