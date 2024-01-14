#include "espwifi.h"

void EspWifi::init() {
  Serial.println("Setting up wifi...");
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASS);
  while (WiFi.waitForConnectResult() != WL_CONNECTED) {
    Serial.print(".");
  }
  Serial.println("done!");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
}

char *EspWifi::fetch(char *url) {
  // Fetch the content of the url
  // ...
  return nullptr;
}
