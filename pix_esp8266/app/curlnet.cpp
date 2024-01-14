#include "curlnet.h"
#include <iostream>

void CurlNet::init() { curl = curl_easy_init(); }

size_t CurlNet::curl_write_f(char *bufptr, size_t size, size_t nitems,
                             string *s) {
  size_t newLength = size * nitems;
  s->append((char *)bufptr, newLength);
  return newLength;
}

string CurlNet::fetch(string url) {
  CURLcode result = CURLE_OK;
  string response;

  if (curl) {
    cerr << "Fetching " << url << endl;
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, curl_write_f);
    curl_easy_setopt(curl, CURLOPT_URL, &url);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);
    curl_easy_perform(curl);
  }

  if (result != CURLE_OK) {
    cerr << "Error: " << curl_easy_strerror(result) << endl;
    return "error";
  }

  // Fetch the content of the url
  // ...
  return response;
}
