/*
  Taller planta sonora Dic 2023

  Moisture: Reads an analog input on pin 0,
    
  DHT11:  Reads a digital input on pin 2, prints the result to the Serial Monitor
  Use Adafruit Unified Sensor

  .... : 

*/

// Incluimos librería DHT
#include <DHT.h>
// Definimos el pin digital donde se conecta el sensor
#define DHTPIN 2
// Dependiendo del tipo de sensor
#define DHTTYPE DHT11
// Inicializamos el sensor DHT11
DHT dht(DHTPIN, DHTTYPE);

// the setup routine runs once when you press reset:
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  // Comenzamos el sensor DHT
  dht.begin();

  //Led read blink
    pinMode(LED_BUILTIN, OUTPUT);
}

// the loop routine runs over and over again forever:
void loop() {
  // Esperamos 5 segundos entre medidas
  delay(4000);
  //Moisture
  int moistureValue = analogRead(A0);

  //DHT
  float h = dht.readHumidity();  // Leemos la humedad relativa
  float t = dht.readTemperature();// Leemos la temperatura en grados centígrados (por defecto)
  // Comprobamos si ha habido algún error en la lectura
  if (isnan(h) || isnan(t) ) {
    //Serial.println("Error obteniendo los datos del sensor DHT11");
    return;
  }

  // Calcular el índice de calor en grados centígrados
  float hic = dht.computeHeatIndex(t, h, false);

  String allSensorsInOneLine = "moistureValue,"+String(moistureValue)+","
                                +"humedadValue,"+String(h)+","
                                +"temperaturaValue,"+String(t)+","
                                +"hic,"+String(hic);

  Serial.println(allSensorsInOneLine);

  //one secon blink show
  digitalWrite(LED_BUILTIN, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(700);                       // wait for a second
  digitalWrite(LED_BUILTIN, LOW);    // turn the LED off by making the voltage LOW
  delay(300);   

}
