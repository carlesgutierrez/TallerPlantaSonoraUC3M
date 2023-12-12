class SensorViz
{
  String sensorName= "";
  float lastValue;
  float value; // valor del sensor real
  float valueMap; // valor del sensor mapeado
  float minValue, maxValue;
  float minRad, maxRad;
  int lastTimeValue;
  int maxTimerAnim = 1000;


  SensorViz(String _name, float _minValue, float _maxValue, int _minRad, int _maxRad) {
    sensorName = _name;
    minValue = _minValue;
    maxValue = _maxValue;
    minRad = _minRad;
    maxRad = _maxRad;
  }

  void updateDataSensor(float _newvalue) {
    value = _newvalue;
    //float auxMoistureMap = map(_newvalue, 600, 1024, 100, 400);
    valueMap = map(_newvalue, minValue, maxValue, minRad, maxRad);

    //detección de nuevos valores y modificar progresivamente el radio?

    //detec sensor diff events
    //Add to Stats..
    //Detect motion...Diff > 2 in x minutes
    if(lastValue != value){
      lastTimeValue = millis(); 
      lastValue = value;
      
      //SEND OSC EVENT
      OscMessage myMessage = new OscMessage("/"+sensorName);
      myMessage.add(60);      
      oscP5.send(myMessage, myRemoteLocation);/* send the message */
      
    }
    
  }
  
  

  void display(float x, float y) {
    fill(#FEC601);//mikado yellow
    stroke(#EA7317);//pumkin
    strokeWeight(10);
    circle(x, y, valueMap);
    
    stroke(#3DA5D9);//Picto Blue
    noFill();
    float animRad = map(millis() - lastTimeValue, 0, 1000, minRad, maxRad);
    circle(x, y, animRad);
    
    strokeWeight(1);
    fill(0);
    //stroke(0);
    noStroke();
    textSize(30);
    textAlign(CENTER, CENTER);

    text(sensorName+" : "+nf(value,0,2), x, y); // Muestra el primer valor
  }
}
