
import ddf.minim.analysis.*;
import ddf.minim.*;
import java.util.Collections;
import java.util.*;
Minim minim;  
AudioPlayer jingle;
FFT fftLin;
FFT fftLog;
float samplerate = 1/60;
float height3;
float height23;
float spectrumScale = 4;
int BAND_COUNT = 30;


PFont font;
ArrayList< ArrayList<Float> > heights = new ArrayList< ArrayList<Float> >();
ArrayList<Float> timestamp = new ArrayList<Float>();
int bandsChosen = 5; // pick the sharpest three
float[] r = new float[bandsChosen];
int initSampleCount = 4; // use how many samples to decide typibands
float[][] typiBandTable = new float[initSampleCount][BAND_COUNT];
int typicalBand = -initSampleCount; // control sampling for 4 data per band
ArrayList<Integer> typiBandsNumber = new ArrayList<Integer>();
boolean isSam = false;
boolean prt=true; 

ParticleSystem[] systems = new ParticleSystem[bandsChosen];

float[] avg = new float[bandsChosen];
int loopbn = 0; // change band by mouseclick
void setup()
{ 
  frameRate(30);
  initialize(); 
  size(900, 1000);
  height3 = height/3;
  height23 = 2*height/3; 
  minim = new Minim(this);
  // ll
  jingle = minim.loadFile("../ll10.mp3", 1024);

  // loop the file
  jingle.play();
  jingle.loop();
  // create an FFT object that has a time-domain buffer 
  //the same size as jingle's sample buffer
  // note that this needs to be a power of two 
  // and that it means the size of the spectrum will be 1024. 
  // see the online tutorial for more info.
  fftLin = new FFT( jingle.bufferSize(), jingle.sampleRate() );

  // calculate the averages by
  //grouping frequency bands linearly. use 30 averages.
  fftLin.linAverages(BAND_COUNT);

  // create an FFT object for calculating logarithmically spaced averages
  fftLog = new FFT( jingle.bufferSize(), jingle.sampleRate() );

  // calculate averages based on a miminum octave width of 22 Hz
  // split each octave into three bands
  // this should result in 30 averages
  fftLog.logAverages( 22, 3 );

  rectMode(CORNERS);
  font = createFont("Georgia", 32);
}

void resetTypicalBand() { 
  println("reseting");
  typicalBand = -initSampleCount; 
  for (int i = 0; i < bandsChosen; i++) { 
    avg[i] = 0;
    heights.get(i).clear();
    println("clear ,heights: ", heights.get(i));
  }
  for (int i = 0; i < bandsChosen; i++) { 
    heights.get(i).add(0.0);
  } 
  typiBandsNumber.clear();
  prt = true;
  isSam = false;
}
void initialize() { 
  for (int i = 0; i < bandsChosen; i++) { 
    heights.add(new ArrayList<Float>());
    avg[i] = 0;
  }
  for (int i = 0; i < bandsChosen; i++) { 
    heights.get(i).add(0.0);
  } 
  float ydelta = height/(bandsChosen+2);
  for (int i = 0; i<bandsChosen; i++) {
    systems[i] = new ParticleSystem((i+1)*ydelta);
  }
}

void keyPressed()
{
  resetTypicalBand();
}