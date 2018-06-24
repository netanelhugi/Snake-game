int pushButtonR = 17;
int pushButtonL = 31;
int bluePin = 40;
int redPin = 30;

void setup() {
  Serial.begin(115200);
  pinMode(pushButtonR, INPUT_PULLUP);
  pinMode(pushButtonL, INPUT_PULLUP);
  pinMode(redPin, OUTPUT); 
  pinMode(bluePin, OUTPUT); 
  }

int old_someR = 1;
int old_someL = 1;


void loop() {

  int on = Serial.read();
  
  
  if(on=='0'){
    digitalWrite(redPin, HIGH);   // sets the LED on
  }
  if(on=='1'){
    digitalWrite(redPin, LOW);   // sets the LED off
  }
  
  int buttonStateR = digitalRead(pushButtonR);
  int buttonStateL = digitalRead(pushButtonL);

  int someR = digitalRead(pushButtonR);
  int someL = digitalRead(pushButtonL);
 
  if(buttonStateR==0){
          Serial.print('R');
  }
  if(buttonStateR==1){
          Serial.print('E');
  }
  if(buttonStateL==0){
          Serial.print('L');
  }
  if(buttonStateL==1){
          Serial.print('N');
  }


}




