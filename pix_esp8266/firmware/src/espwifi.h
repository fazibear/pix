#pragma once

#include "network.h"
#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <string>

class EspWifi : public Network {
public:
  void init();
  string fetch(string);
};
