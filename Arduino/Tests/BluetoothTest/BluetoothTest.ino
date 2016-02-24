void setup() {
    Serial.begin(57600); 
}

void loop() {
  delay(30);
  Serial.write(1);
  Serial.write(2);
}
