void setup() {
  
  Serial.begin(9600);             // Serial Comm begin
  
}

void loop() {                     // Infinite loop
  
  Serial.println(analogRead(A0)); // Lecture in analog pin A0 is sended through serial
  
}


