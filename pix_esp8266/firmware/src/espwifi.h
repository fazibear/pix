#pragma once

#include "network.h"
#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>

class EspWifi : public Network {
public:
  void init();
  char *fetch(char *);
};
