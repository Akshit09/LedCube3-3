/**
  * This sketch demonstrates how to use the BeatDetect object in FREQ_ENERGY mode.<br />
  * You can use <code>isKick</code>, <code>isSnare</code>, </code>isHat</code>, <code>isRange</code>, 
  * and <code>isOnset(int)</code> to track whatever kind of beats you are looking to track, they will report 
  * true or false based on the state of the analysis. To "tick" the analysis you must call <code>detect</code> 
  * with successive buffers of audio. You can do this inside of <code>draw</code>, but you are likely to miss some 
  * audio buffers if you do this. The sketch implements an <code>AudioListener</code> called <code>BeatListener</code> 
  * so that it can call <code>detect</code> on every buffer of audio processed by the system without repeating a buffer 
  * or missing one.
  * <p>
  * This sketch plays an entire song so it may be a little slow to load.
  */

import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import cc.arduino.*;
import java.util.Random;



Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;
Arduino arduino;

int [] ledPinCathode={4, 5, 6, 7};
int [] ledPinAnode={8, 9, 10, 11};


float kickSize, snareSize, hatSize;

void setup() {
  size(512, 200, P3D);
  
  minim = new Minim(this);
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  
  song = minim.loadFile("005.mp3", 2048);
  song.play();
  // a beat detection object that is FREQ_ENERGY mode that 
  // expects buffers the length of song's buffer size
  // and samples captured at songs's sample rate
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  // set the sensitivity to 300 milliseconds
  // After a beat has been detected, the algorithm will wait for 300 milliseconds 
  // before allowing another beat to be reported. You can use this to dampen the 
  // algorithm if it is giving too many false-positives. The default value is 10, 
  // which is essentially no damping. If you try to set the sensitivity to a negative value, 
  // an error will be reported and it will be set to 10 instead. 
  beat.setSensitivity(100);  
  kickSize = snareSize = hatSize = 16;
  // make a new beat listener, so that we won't miss any buffers for the analysis
  bl = new BeatListener(beat, song);  
  textFont(createFont("Helvetica", 16));
  textAlign(CENTER);
  for(int i=0; i<4; i++){
  arduino.pinMode(ledPinCathode[i], Arduino.OUTPUT);}    
  for(int i= 0;i<4;i++){
arduino.pinMode(ledPinAnode[i], Arduino.OUTPUT);
}
}

void draw() {
  background(255);
  fill(0);
    int[] pin = new int[4];
        Random rm = new Random();
        int num  = rm.nextInt(16);
        System.out.println("Random number is "+num+"\n");
        String n = Integer.toBinaryString(num);
        char[] arr = new char[4];
        int p = n.length();
        arr = n.toCharArray();
        
            //for(int i =0;i<arr.length;i++)
            //System.out.println(arr[i]);           
        if(p==1)
        {
          pin[3]=arr[0]-'0';
          pin[2]=0;
          pin[1]=0;
          pin[0]=0;
        }
        else if(p==2)
        {
            pin[3]=arr[1]-'0';
            pin[2]=arr[0]-'0';
            pin[1]=0;
            pin[0]=0;
        }
        else if(p==3)
        {
            pin[3]=arr[2]-'0';
            pin[2]=arr[1]-'0';
            pin[1]=arr[0]-'0';
            pin[0]=0;
        }
        else
        {
            pin[3]=arr[3]-'0';
            pin[2]=arr[2]-'0';
            pin[1]=arr[1]-'0';
            pin[0]=arr[0]-'0';
        }
     
      
    
    if(beat.isKick()) {
    if(pin[0]==pin[1]){
      arduino.digitalWrite(ledPinCathode[0], 1);
      arduino.digitalWrite(ledPinCathode[1], 1);
      arduino.digitalWrite(ledPinCathode[2], 0);
      arduino.digitalWrite(ledPinCathode[3], 0);}
      else if(pin[1]==pin[2]){
      arduino.digitalWrite(ledPinCathode[0], 0);
      arduino.digitalWrite(ledPinCathode[1], 0);
      arduino.digitalWrite(ledPinCathode[2], 0);
      arduino.digitalWrite(ledPinCathode[3], 0);}
      else if(pin[2]==pin[3]){
      arduino.digitalWrite(ledPinCathode[0], 0);
      arduino.digitalWrite(ledPinCathode[1], 0);
      arduino.digitalWrite(ledPinCathode[2], 1);
      arduino.digitalWrite(ledPinCathode[3], 1);}
      else if(pin[3]==pin[1]){
      arduino.digitalWrite(ledPinCathode[0], 1);
      arduino.digitalWrite(ledPinCathode[1], 1);
      arduino.digitalWrite(ledPinCathode[2], 1);
      arduino.digitalWrite(ledPinCathode[3], 1);}
      arduino.digitalWrite(ledPinAnode[0], pin[0]);
      arduino.digitalWrite(ledPinAnode[1], pin[1]);
      arduino.digitalWrite(ledPinAnode[2], pin[2]);
      arduino.digitalWrite(ledPinAnode[3], pin[3]);// set the LED on
      kickSize = 32;
  }
  
  if(beat.isSnare()) {
  
      if(pin[0]==pin[1]){
      arduino.digitalWrite(ledPinCathode[0], 1);
      arduino.digitalWrite(ledPinCathode[1], 0);
      arduino.digitalWrite(ledPinCathode[2], 0);
      arduino.digitalWrite(ledPinCathode[3], 1);}
      else if(pin[1]==pin[2]){
      arduino.digitalWrite(ledPinCathode[0], 0);
      arduino.digitalWrite(ledPinCathode[1], 1);
      arduino.digitalWrite(ledPinCathode[2], 0);
      arduino.digitalWrite(ledPinCathode[3], 1);}
      else if(pin[2]==pin[3]){
      arduino.digitalWrite(ledPinCathode[0], 0);
      arduino.digitalWrite(ledPinCathode[1], 1);
      arduino.digitalWrite(ledPinCathode[2], 1);
      arduino.digitalWrite(ledPinCathode[3], 0);}
      else if(pin[3]==pin[1]){
      arduino.digitalWrite(ledPinCathode[0], 1);
      arduino.digitalWrite(ledPinCathode[1], 0);
      arduino.digitalWrite(ledPinCathode[2], 1);
      arduino.digitalWrite(ledPinCathode[3], 0);}
    
      arduino.digitalWrite(ledPinAnode[0], pin[0]);
      arduino.digitalWrite(ledPinAnode[1], pin[1]);
      arduino.digitalWrite(ledPinAnode[2], pin[2]);
      arduino.digitalWrite(ledPinAnode[3], pin[3]);// set the LED on
      snareSize = 32;
  }
  if(beat.isHat()) {
          if(pin[0]==pin[1]){
      arduino.digitalWrite(ledPinCathode[0], 1);
      arduino.digitalWrite(ledPinCathode[1], 0);
      arduino.digitalWrite(ledPinCathode[2], 0);
      arduino.digitalWrite(ledPinCathode[3], 0);
    
    arduino.digitalWrite(ledPinCathode[0], 1);
      arduino.digitalWrite(ledPinCathode[1], 0);
      arduino.digitalWrite(ledPinCathode[2], 1);
      arduino.digitalWrite(ledPinCathode[3], 1);}
      else if(pin[1]==pin[2]){
      arduino.digitalWrite(ledPinCathode[0], 0);
      arduino.digitalWrite(ledPinCathode[1], 1);
      arduino.digitalWrite(ledPinCathode[2], 0);
      arduino.digitalWrite(ledPinCathode[3], 0);
      
      arduino.digitalWrite(ledPinCathode[0], 0);
      arduino.digitalWrite(ledPinCathode[1], 1);
      arduino.digitalWrite(ledPinCathode[2], 1);
      arduino.digitalWrite(ledPinCathode[3], 1);
    }
      else if(pin[2]==pin[3]){
      arduino.digitalWrite(ledPinCathode[0], 1);
      arduino.digitalWrite(ledPinCathode[1], 1);
      arduino.digitalWrite(ledPinCathode[2], 0);
      arduino.digitalWrite(ledPinCathode[3], 1);
      
    arduino.digitalWrite(ledPinCathode[0], 0);
      arduino.digitalWrite(ledPinCathode[1], 0);
      arduino.digitalWrite(ledPinCathode[2], 0);
      arduino.digitalWrite(ledPinCathode[3], 1);}
      else if(pin[3]==pin[1]){
      arduino.digitalWrite(ledPinCathode[0], 1);
      arduino.digitalWrite(ledPinCathode[1], 1);
      arduino.digitalWrite(ledPinCathode[2], 1);
      arduino.digitalWrite(ledPinCathode[3], 0);
      
    arduino.digitalWrite(ledPinCathode[0], 0);
      arduino.digitalWrite(ledPinCathode[1], 0);
      arduino.digitalWrite(ledPinCathode[2], 1);
      arduino.digitalWrite(ledPinCathode[3], 0);}  
  
      arduino.digitalWrite(ledPinAnode[0], pin[0]);
      arduino.digitalWrite(ledPinAnode[1], pin[1]);
      arduino.digitalWrite(ledPinAnode[2], pin[2]);
      arduino.digitalWrite(ledPinAnode[3], pin[3]);// set the LED on*/
      hatSize = 32;
  }
  else{
        for(int i=0;i<4;i++){  
        arduino.digitalWrite(ledPinCathode[i], 0);
      arduino.digitalWrite(ledPinAnode[i], 0);}}// set the LED off}*/
  textSize(kickSize);
  text("KICK", width/4, height/2);
  textSize(snareSize);
  text("SNARE", width/2, height/2);
  textSize(hatSize);
  text("HAT", 3*width/4, height/2);
  kickSize = constrain(kickSize * 0.95, 16, 32);
  snareSize = constrain(snareSize * 0.95, 16, 32);
  hatSize = constrain(hatSize * 0.95, 16, 32);
}

void stop() {
  // always close Minim audio classes when you are finished with them
  song.close();
        for(int i=0;i<4;i++){  
        arduino.digitalWrite(ledPinCathode[i], 0);
      arduino.digitalWrite(ledPinAnode[i], 0);}
  // always stop Minim before exiting
  minim.stop();
  // this closes the sketch
  super.stop();
}