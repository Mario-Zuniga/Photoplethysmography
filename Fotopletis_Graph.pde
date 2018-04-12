 // Information for Serial Port
 import processing.serial.*;
 Serial myPort;        
 
// Global variables
int xPos = 1, latidos = 0, datoAnterior, frecuenciaProm,frecuencia[] = new int[10];       
float inBytePrev = 0, inByte;
boolean latido= false;
double tiempo = 0;
 
 
void setup () {
   size(800, 400);                                         // Creates screen 
   myPort = new Serial(this, Serial.list()[0], 9600);      // Serial Port init
   myPort.bufferUntil('\n');
   background(0);                                          // Background color
   texto();                                                // Prints text
   
}

// Draw function, not used in this case, but has to exist
void draw () {
   
}
 
void serialEvent (Serial myPort) {
     String inString = myPort.readStringUntil('\n');    // Stores string information
     
     // Checks if the full string arrived 
     if (inString != null) {
       // If it does, it trims it, changes to a float value and sends it to check the heart beat
       inString = trim(inString);                   
       inByte = float(inString);                     
       checaLatido(int(inByte));                      
       inByte = map(inByte, 0, 1023, 50, height);    // The value obtained is adjusted to fit the screen
         
       // Draws line 
       if (xPos != 0) {
         stroke(255,128,0);                                               
         line(xPos-1, height - inBytePrev, xPos, height - inByte);      // A line is drawed in order to continue the real time graph
        }
        
        inBytePrev = inByte;   // We save the old value
         
        // We check if the line reaches the end of the screen
        if (xPos >= width) {
          
          // If it does, the line and screen resets
          xPos = 0;
          background(0);
          texto();
          
         } else {
           xPos++;    // Increases position for next value
         }
     }
 }
 
 //Esta función actualiza el texto en pantalla
void texto() {
    stroke(0);    fill(0);         
    rect(550,25,800,50 );                                                        // Creates a rectangle for text
    fill(255,255,0);                                                             // Changes font color to yellow
    textSize(18);
    text("Fotopletismógrafo\n", 300,40);                                         // Prints "Fotopletismógrafo"
    fill(255,0,0);                                                               // Changes font color to red
    textSize(12);                 
    text("Frecuencia cardiaca: "+ frecuencia[0], 550, 50);                       // Prints updated heart rate
    textSize(11);
    fill(255,51,153);                                                            // Changes font color to purple pink
    text("Ruben Gallardo Torres        Mario Eugenio Zúñiga Carrillo",0,380);    // Prints names of team members
}
 
// This function checks heart beats and obtains the heart rate
void checaLatido(int dato) {
  int i;
  
  // Checks if there is a heart beat
  if (dato > 400 && !latido && datoAnterior > dato) {
    latido=true;
    latidos += 1;
    frecuencia[0] = (int)(60000 / ((millis() - tiempo)));      // With the time obtained and the previous time, we get the heart rate
    tiempo = millis();                                         // Resets time for next calculation
    texto();                                                   // Updates text on screen
    
  } else if (dato < 400) {
    latido = false; 
    
    // If we don't get any heart beat value for 3 seconds, the heart rate value goes to 0
    if(millis() - tiempo > 3000 &&  latidos != 0) {             
      latidos=0;
      for (i=0;i<10;i++)
        frecuencia[i] = 0;
        
      frecuenciaProm = 0;
      texto();
    }
  }
  datoAnterior = dato;
}
  
