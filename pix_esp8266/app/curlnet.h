#pragma once

#include "network.h"
#include <curl/curl.h>
#include <string>

using namespace std;

class CurlNet : public Network {
private:
  CURL *curl;

public:
  void init();
  string fetch(string);
  static size_t curl_write_f(char *, size_t, size_t, string *);
};
