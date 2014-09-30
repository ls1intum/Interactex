
#include <Boards.h>

int led = 13;

void setup() {
  // initialize the digital pin as an output.
  pinMode(led, OUTPUT);
  pinMode(12, INPUT_PULLUP); // disable output driverdigita'
  digitalWrite(led,0);
}

// the loop routine runs over and over again forever:
void loop() {
  readPort(1);
  
  int val = digitalRead(12);
  
  if(val == 0){
    digitalWrite(led,1);
  } else {
    
    digitalWrite(led,0);
  }
}
