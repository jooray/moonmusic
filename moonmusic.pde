import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import fullscreen.*;
import processing.video.*;

// SETTINGS BEGIN
boolean fullScreen = true;
String arssPath = "/Users/juraj/arss/arss";

boolean bwMode = true;

// SETTINGS END


FullScreen fs;

Capture myCapture;



int camWidth; 
int camHeight;
PImage camImg;
PImage lastImg;
PImage layerImg[];
AudioSnippet layerSound[];
boolean doInvert = true;

float contrast = 0.2;

Minim minim;
AudioOutput out;

AudioSnippet aS;

void setup() 
{
  size(1024, 768, P2D);
  
   if (fullScreen) {
   fs = new FullScreen(this);
   fs.enter();
   PImage c = createImage(16, 16, RGB);
   c.set(7,7, color(100, 0, 0));
   cursor(c, 7, 7);
 }


  // The name of the capture device is dependent on
  // the cameras that are currently attached to your 
  // computer. To get a list of the 
  // choices, uncomment the following line 
  //println(Capture.list());
  
  // To select the camera, replace "Camera Name" 
  // in the next line with one from Capture.list()
  //myCapture = new Capture(this, width, height, "DV Video", 30);
  
  // This code will try to use the camera used
  camWidth = 2*(width/3);
  camHeight = (int)abs(0.7*2*(width/3));
  background(0);
  myCapture = new Capture(this, camWidth , camHeight, 2);
  frameRate(5);
  camImg = createImage(camWidth, camHeight, RGB);
  lastImg = createImage(camWidth, camHeight, RGB);


  minim = new Minim(this);
  
  layerSound = new AudioSnippet[4];
  layerImg = new PImage[4];
  for (int i=0;i<4;i++) {
    layerSound[i]=null;
   layerImg[i]= createImage(camWidth, camHeight, RGB);
  }
  //aS.loop();
 
}

void captureEvent(Capture myCapture) {
  myCapture.read();
}

void drawAudioFrame(int x, int y, AudioSnippet aS, PImage img) {
  if (img != null)
  image(img, x, y, camWidth/3, camHeight/3);
  
  noFill();
  stroke(255);
  rect(x-1, y-1, (camWidth/3) + 1, (camHeight/3) + 1);

  stroke(255,0,0);
  fill(255,0,0);

  if ((aS != null) && (aS.isPlaying())) {
  rect(x, y+(camHeight/3)+40, camWidth/3,1);
  float percent = 100*aS.position() / aS.length();
  rect(x + ((camWidth/3) * (percent/100)), y+(camHeight/3), 7,40);
  }  else {
   line(x, y+(camHeight/3)+40, x+camWidth/3, y+(camHeight/3));
   line(x+camWidth/3, y+(camHeight/3)+40, x, y+(camHeight/3));
  }
 
}
void draw() {
  background(0);
  
  
  stroke(255);
  
  text(" LAST.FM: 1.5.4",950,740);

  rect(0,0,camWidth+1,camHeight+1);
  camImg.copy(myCapture, 0, 0, camWidth, camHeight, 0, 0, camWidth, camHeight);
  image(camImg,50, camHeight+50, camWidth/3, camHeight/3);
  
  if (bwMode) {
  camImg.filter(THRESHOLD, contrast);
  } else {
   camImg.filter(GRAY);
   
   // greyscale mode
   camImg.loadPixels();
   
   
   /*long value=0;
   int count=0;
  
   for (int x=0;x<camWidth-20;x+=20)
   for (int y=0;y<camHeight-20;y+=20) {
    value+=camImg.get(x,y);
    count++;
   } 
  
  int avg=(int) (value/count);
  int adjustment=127-avg;*/
  
  if (contrast != 0.2) {
  for (int x=0;x<camWidth;x++)
   for (int y=0;y<camHeight;y++) {
     if (red(camImg.pixels[x+(y*camWidth)]) > 255*(1-(contrast*1.8)))
      camImg.pixels[x+(y*camWidth)] = color(255);
   } 
   
   camImg.updatePixels();
  }
  

  }
  
  
  if (doInvert) camImg.filter(INVERT);
  image(camImg, 0, 0);
  
  
  drawAudioFrame(100 + camWidth/3, (camHeight+50), null, lastImg);
  
  for (int i=0; i<4; i++) {
     drawAudioFrame(camWidth+40, 20 + (i * (camWidth/3 + 30)), layerSound[i], layerImg[i]);
  }

  noFill();
  
}

void loadWaveToLayer(int i) {
  if (layerSound[i]!= null)
    layerSound[i].pause();
   File f = new File("/tmp/camImg.wav");
   if (f.exists()) 
   try {
   layerSound[i] = minim.loadSnippet("/tmp/camImg.wav");
   } catch (Exception e) {}
   
   layerImg[i].copy(lastImg,0,0,camWidth,camHeight,0,0,camWidth,camHeight);
 }
 
 void toggleLayer(int i) {
   
   if (layerSound[i]!=null) {
      if (layerSound[i].isPlaying())
     layerSound[i].pause();
    else layerSound[i].loop(); 
   }
 }
 

void keyPressed() {
 
  // save image to file
 if (key == ENTER) {
   camImg.save("/tmp/camImg.bmp");
   lastImg.copy(camImg,0,0, camWidth, camHeight, 0,0, camWidth, camHeight);
   try {
   Runtime.getRuntime().exec(arssPath + " -q /tmp/camImg.bmp /tmp/camImg.wav -min 20 -max 20000 --pps 100 -r 48000 -f 8 -s");
   } catch (Exception e) {
    System.err.println("Nieco sa dojebalo: " + e); 
   }
   delay(1500);
 } 
 
 if (key == '1') toggleLayer(0); 
 if (key == '2') toggleLayer(1); 
 if (key == '3') toggleLayer(2); 
 
 if (key == '!') loadWaveToLayer(0);
 if (key == '@') loadWaveToLayer(1);
 if (key == '#') loadWaveToLayer(2);
 
 if (key == 'z') contrast = 0.15;
 if (key == 'x') contrast = 0.2;
 if (key == 'c') contrast = 0.25;
 if (key == 'v') contrast = 0.3;
 if (key == 'b') contrast = 0.35;
 if (key == 'n') contrast = 0.4;
 if (key == 'm') contrast = 0.45;
 if (key == ',') contrast = 0.5;   

if (key == 'a') bwMode = !bwMode; 
if (key == 'i') doInvert = !doInvert; 

}




// sound

void stop()
{
// always closes audio I/O classes
out.close();
// always stop your Minim object
minim.stop();

super.stop();
}
