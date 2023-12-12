import processing.serial.*;

//DATA VIZ
float maxSizeCirculo = 300;
int xPos = 0;
int yPos = 0;
Boolean recibiendoDatos = false;

//SENSORES ARDUINO
Serial myPort;  // The serial port
String rawSerialText;
String[] portsAvailable;
float moistureFloat = -1;
float humityFloat;
float tempFloat;


import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

SensorViz sensorMoistureViz;
SensorViz sensorTempViz;
SensorViz sensorHumityViz;
//------------------------------------------
void setup() {
  size(1024, 768);
  

  //OSC
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 4560);

  //SENSOR ARDUINO
  // List all the available serial ports
  portsAvailable = Serial.list();
  printArray(portsAvailable);

  if (portsAvailable.length>0) {
    // Open the port you are using at the rate you want:
    myPort = new Serial(this, Serial.list()[4], 9600);
  }


  //DATA VIZ
  frameRate(50);
  sensorMoistureViz = new SensorViz("Moist", 600, 1024, 100, 300);
  
  //Rango  de 0ºC a 50ºC . Precisión  a 25ºC ± 2ºC //Temperatura ambiente: temperatura en un determinado lugar.
  sensorTempViz = new SensorViz("Temp", 20, 50, 100, 300);
  //Rango  de 20% RH a 90% RH. Precisión  entre 0ºC y 50ºC ± 5% RH  //Humedad relativa: describe la cantidad de agua que se transporta por el aire, es importante para determinar el desarrollo de las nubes y el factor precipitación.
  sensorHumityViz = new SensorViz("Hum", 20, 90, 100, 300);
 /*
  float auxHumMap = map(humityFloat, 600, 1024, 100, 00)
 sensorHumityViz.updateDataSensor(auxHumMap);
 
 float auxTempMap = map(tempFloat, 600, 1024, 100, 400)
 sensorTempViz.updateDataSensor(auxTempMap);
 */
       
}

//------------------------------------------
void draw() {
    
  background(100);
  
  //SENSOR ARDUINO
  if (portsAvailable.length>0) {
    readSerialSensors();
  }

  //DATA VIZ
  pintandoDatosSensores();
}

//-----------------------------------------
void pintandoDatosSensores() {

  //paleta de colores frios calidos
  //https://coolors.co/2364aa-3da5d9-73bfb8-fec601-ea7317
  sensorMoistureViz.display(width*0.25, height*0.5);
  
  sensorTempViz.display(width*0.5, height*0.5);
  sensorHumityViz.display(width*0.75, height*0.5);
}

//------------------------------------------
void readSerialSensors() {
  //READ ALL SENSORS ARDUINO
  if ( myPort.available() > 0) {  // If data is available,
    rawSerialText = myPort.readStringUntil('\n');         // read it and store it in val
    recibiendoDatos = true;
  }
  println(rawSerialText); //print it out in the console

  //proteger de que mis datos de lectura valgan null
  if (recibiendoDatos == true) {
    String[] serialTextSplitArray = split(rawSerialText, ',');
    if (serialTextSplitArray.length >0) {
      print(serialTextSplitArray);
      moistureFloat = float(serialTextSplitArray[1]);
      humityFloat = float(serialTextSplitArray[3]);
      tempFloat = float(serialTextSplitArray[5]);
      // hic...

      //Map values...into widht height values?

      sensorMoistureViz.updateDataSensor(moistureFloat);
      sensorTempViz.updateDataSensor(humityFloat);
      sensorHumityViz.updateDataSensor(tempFloat);

 
    }
  }
}



void mousePressed() {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/test");

  myMessage.add(60);
  myMessage.add(2);
  myMessage.add(1);

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation);
}

void keyPressed() {

  println("keyPressed ="+key);
  OscMessage myMessage = new OscMessage("/tecla8");


  if (key == '8') {
    /* send the message */
    oscP5.send(myMessage, myRemoteLocation);
    print("send8TatasOSC()");
  }
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}
