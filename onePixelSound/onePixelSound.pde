/*
 * Creative Coding - original Code from Futurelearn Course on "Creative Coding"
 * Week 4, 03 - one pixel cinema
 * by Indae Hwang and Jon McCormack
 * Updated 2016
 * Copyright (c) 2014-2016 Monash University
 * Modifications (c) 2017 by Herbert Mehlhose

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
 * This simple sketch demonstrates how to read pixel values from an image
 * It simulates a 10 pixel "scanner" that moves from the top to the bottom of the image
 * reading the colour values for 10 equally spaced points, then displaying those colours
 * as vertical bars on the left half of the screen.
 *
 * Code adaptions by Herbert Mehlhose:
 * Play 10 sinus tones which are dependent on the color hue value. 
 * Each tone corresponds to one of the sampled colour values, which are updated every second frame.
 * Tones can be switched on/off by keys '1' to '0' from left to right, where '1' is
 * the left scanner and '0' is the 10th scanner on the right.
 * In addition
 * - Added file selection dialog and possibility to load files of different size
 * - Addied video capture functionality (requires ffmpeg and some processing libs)
 */

import processing.sound.*;    // sine wave generators...
import com.hamoid.*;          // https://www.funprogramming.org/VideoExport-for-Processing/
import ddf.minim.*;           // import minim to record sound
import javax.sound.sampled.*; // to use mixer

int maxWidth = 1800;
int maxHeight = 700;
Minim minim;
AudioInput in;
AudioRecorder recorder;
Mixer mixer = null;
String requiredMixerNameString = "Stereo Mix";  // mixer name starts with...
VideoExport videoExport;
PImage myImg = null;
int myWidth, myHeight;
color[] pixelColors;
TriOsc[] sine;
float[] amp;
int scanLine;  // vertical position
boolean isRecording = false;
float movieFPS = 30;   // take care here with 60 fps of processing

// using TriOsc instead of SinOsc... no errors for bad index...

void setup() {
  //size(700, 622);
  pixelColors = new color[10];
  sine = new TriOsc[10];
  amp = new float[10];
  for(int i=0; i<10; i++) {
    sine[i] = new TriOsc(this);
  }
  scanLine = 0;
  smooth(4);
 
  // Try to get a suitable mixer object that allows to capture
  // the produced sound.
  Mixer.Info[] mixerInfo = AudioSystem.getMixerInfo();
  String mixerName;
  for(int i = 0; i < mixerInfo.length; i++) {
    mixerName = mixerInfo[i].getName();
    println(i + ": " + mixerName);
    if (mixerName.startsWith(requiredMixerNameString)) {
      minim = new Minim(this);
      mixer = AudioSystem.getMixer(mixerInfo[i]);
      minim.setInputMixer(mixer);
      println(">>> Have set '" + mixerName + "' as inputMixer");
    } 
  }
  if (mixer != null) {
    in = minim.getLineIn(Minim.STEREO);
    recorder = minim.createRecorder(in, dataPath("sound.wav"));
    // setup recording video export
    videoExport = new VideoExport(this);
    videoExport.setFrameRate(movieFPS);
    videoExport.setAudioFileName("sound.wav");
    // forget path to ffmpeg - might be useful to uncomment for first run
    //videoExport.forgetFfmpegPath();
  } else {
      println("No suitable mixer device found, disabling recording function...");
  }
  // Select an image to use at runtime using a file dialog
  selectInput("Please select an image to listen to:", "selectFile");
}

/* 
 * function getImage()
 * Load an image passed by filename and adjust window size to fit
 * surface.setSize() is the solution to set size depending on
 * variable values.
 */
PImage getImage(String filename) {
  PImage i = loadImage(filename);
  int imgWidth = i.width;
  int imgHeight = i.height;
  float wfactor = 1.0;
  float hfactor = 1.0;
  println("Image '" + filename + "': " + imgWidth + " * " + imgHeight);
  // if image is too large to fit into given window size limits, adjust
  // the image. Make sure to keep the aspect ratio. No upscaling!
  if (imgWidth > maxWidth/2) {
    wfactor = (float)(maxWidth/2) / imgWidth;
    println("Image too wide, wfactor = " + wfactor);
  }
  if (imgHeight > maxHeight) {
    hfactor = (float)(maxHeight) / imgHeight;
    println("Image too high, hfactor = " + hfactor);
  }
  // the smaller factor wins
  if(wfactor < hfactor) {
    imgHeight *= wfactor;
    imgWidth *= wfactor;
    //i.resize(imgWidth, imgHeight);
    i.resize(imgWidth-imgWidth%2, imgHeight-imgHeight%2);
    println("Resizing by factor " + wfactor);
    
  } else if ((hfactor <= wfactor) && hfactor < 1.0) {
    imgHeight *= hfactor;
    imgWidth *= hfactor;
    //i.resize(imgWidth, imgHeight);
    i.resize(imgWidth-imgWidth%2, imgHeight-imgHeight%2);
    println("Resizing by factor " + wfactor);
  }
  println("Screen: " + i.width + " x " + i.height);
  surface.setSize(2*imgWidth, imgHeight);
  return i;
}


void draw() {
  background(0);
  
  // this one is a hack to wait until the user dialog is finshed
  // with selecting a file to play...
  if (myImg == null) {
    return;
  }

  // read the colours for the current scanLine
  for (int i=0; i<10; i++) {
    //pixelColors[i] = myImg.get(17+i*35, scanLine);
    pixelColors[i] = myImg.get(myWidth/20+i*myWidth/10, scanLine);
    float hueval = (float)hue(pixelColors[i]);
    float brightval = (float)brightness(pixelColors[i]);
    sine[i].freq(map(hueval,0.0,255.0,80.0,1500.0));
    sine[i].pan(map(brightval,0.0,255.0,-1.0,1.0));
  }

  // draw the sampled pixels as verticle bars
  for (int i=0; i< 10; i++) {
    noStroke();
    if(amp[i] > 0.0) {
      fill(pixelColors[i]);
    } else {
      fill(0, 0, 0);
    }
    rect(i*myWidth/10, 0, myWidth/10, myHeight);
  }

  // draw the image
  image(myImg, width/2, 0);

  // increment scan line position every second frame
  if (frameCount % 2 == 0) {
    scanLine ++;
  }

  // recording automatically ends after scanline reaches bottom of image
  if (scanLine > height) {
    if (isRecording) {
      finalizeVideo();
      isRecording = !isRecording;
    }
    scanLine = 0;
  }

  // draw circles over where the "scanner" is currently reading pixel values
  for (int i=0; i<10; i++) {
    // yellow ones are the active "voices"
    if(amp[i] > 0.0) {
      stroke(255, 255, 0);
    } else {
      stroke(0, 0, 0);
    }
    noFill();
    //ellipse(width/2 + 17 + i*35, scanLine, 5, 5 );
    ellipse(width/2 + myWidth/20 + i*myWidth/10, scanLine, 5, 5 );
  }
  
  // record movie - only every second frame to match
  // requested fps = 30...
  if ((isRecording) && (frameCount % 2 == 0)) {
    videoExport.saveFrame();
  }
}

/*
 * Stop audio playback and cleanup
 */
void stop() {
  println("Stopping and cleaning up...");
  if (mixer != null) {
    in.close();
    minim.stop();
  }
  for(int i=0;i < 10;i++){
    sine[i].stop();  
  }
  super.stop();
}

/*
 * keyReleased function
 */
void keyReleased() {
  if (keyCode >= 48 && keyCode <= 57) {
    //            0                9
    // keycode represents the ASCII value...
    // only 0 to 9 are of interest for our 10 columns / sine waves
    int n = (keyCode == 48 ? 9 : keyCode - 49);
    amp[n] = 1.0 - amp[n];
    sine[n].amp(amp[n]);
  }
  
  if (key == 'n') {
    println("Starting new image...");
    for(int i=0;i < 10;i++){
      sine[i].stop();  
    }
    selectInput("Please select an image to listen to:", "selectFile");
  }
  
  if ((key == 'r') && (mixer != null)) {
    if (isRecording) {
      finalizeVideo();
    } else {
      // recording resets scanline to top of image
      scanLine = 0;
      videoExport.startMovie();
      recorder.beginRecord();
    }
    isRecording = !isRecording;
  }
}

/*
 * selectFile function
 * Used to select the file to be used.
 */
void selectFile(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("You selected " + selection.getAbsolutePath());
    myImg = getImage(selection.getAbsolutePath());
    myWidth = myImg.width;
    myHeight = myImg.height;
    println("Image size " + myWidth + " x " + myHeight);
    //delay(7000);

    for(int i=0; i<10; i++) {
      amp[i] = 1.0;
      sine[i].amp(amp[i]);
      sine[i].play();
    }
    scanLine = 0;
  }
}

void finalizeVideo() {
  if (isRecording) {
    recorder.endRecord();
    recorder.save();
    // call endMovie AFTER creating the sound file
    videoExport.endMovie();
    // and remove the intermediate sound file
    File sound = new File(dataPath("sound.wav"));
    if(sound.exists()) {
      sound.delete();
    }
  }
}