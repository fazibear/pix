#pragma once

#include "network.h"
#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <string>

class EspWifi : public Network {
public:
  void init();
  std::string fetch(std::string);
};
