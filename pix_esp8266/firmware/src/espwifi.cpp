#include "espwifi.h"
#include <string>

using namespace std;

void EspWifi::init() {
  Serial.println("Setting up wifi...");
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASS);
  while (WiFi.waitForConnectResult() != WL_CONNECTED) {
    Serial.print(".");
    delay(2000);
  }
  Serial.println("done!");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
}

string EspWifi::fetch(string url) { return ""; }
