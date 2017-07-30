/** 
   Author : Dinoswarleafs (twitter.com/Dinoswarleafs) 
   Simple input on a slider like a TrackBar on Visual Studio
   
   Parameters/Constructor :
   TrackBar(a, b, c, d, e, f)
   
   a = x-coordinate of bar
   b = y-coordinate of bar
   c = length of bar
   d = value of first tick
   e = value of last tick
   f = value between ticks (1 = 1, 2, 3, 4 | 2 = 1, 3, 5, 7 ...)
   
   Draw Loop :
   (name).update();
   (name).display();
   
   Get Slider's Value :
   (name).selectedValue (is float)
   
   Other customizations :
   There are a few things I just put in since they seemed too trivial to put in the constructor
   
   Change circle selector size    - cSize = new PVector(x, y)
   Change height of ticks         - tickHeight = y
   Change colors (display())      - fill(color)
   Text on ticks (display())      - uncomment text(...) in for loop
   Text on side ticks (display()) - uncomment 2 text(...) lines after foor loop
   
   
   To Do: 
    - Exemption Handling
    - Scaling/Resizing
    - Prettier Bar?
*/

class TrackBar {
  
  ArrayList<PVector> indexes = new ArrayList<PVector>();
  PVector startPos, endPos, sideValues, sCircle, cSize;
  float increment, range, indexRange, gapLength, tickHeight, selectedValue;
  boolean isActivated;
  
  TrackBar(float startX, float startY, float xLength, float startValue, float endValue, float increment_) {
    startPos       = new PVector(startX, startY);
    endPos         = new PVector(startX + xLength, startY);
    sideValues     = new PVector(startValue, endValue);
    sCircle        = new PVector(startX, startY);
    cSize          = new PVector(20, 20);
    increment      = increment_;
    range          = endPos.x - startPos.x;
    if (sideValues.x == 0 || sideValues.y == 0)
     indexRange    = abs(sideValues.x - sideValues.y) + 1;
    else 
     indexRange    = abs(sideValues.x - sideValues.y); 
    gapLength      = range / (indexRange - 1);
    tickHeight     = 20;
    selectedValue  = sideValues.x; 
    
    float value = sideValues.x;
    float i = startPos.x;
    for (; i < endPos.x; i += gapLength) {
     indexes.add(new PVector(value, i));
     value += increment;
    }
    indexes.add(new PVector(sideValues.y, i));
  }
  
  void update() {
   if (mousePressed && clickedCircle()) 
    isActivated = true;
   if (isActivated && mousePressed)
    //if (startPos.x < mouseX && mouseX < endPos.x)
     sCircle.x = mouseX;
   else {
    isActivated = false;
    for (int i = 0; i < indexes.size(); i++)
     if (sCircle.x < startPos.x)
      sCircle.x = indexes.get(0).y;
     else if (sCircle.x > endPos.x)
      sCircle.x = indexes.get(indexes.size() - 1).y;
     else if (abs(sCircle.x - indexes.get(i).y) < gapLength / 2) {
       sCircle.x = indexes.get(i).y;
       selectedValue = indexes.get(i).x;
     }
   }
  }
  
  void display() {
    stroke(0);
    strokeWeight(2);
    fill(100);
    line(startPos.x, startPos.y, endPos.x, endPos.y);
    textAlign(CENTER);
    for (int i = 0; i < indexes.size(); i++) {
     line(indexes.get(i).y, startPos.y + tickHeight, indexes.get(i).y, startPos.y - tickHeight);
     //text((int) indexes.get(i).x, indexes.get(i).y, startPos.y + (tickHeight * 2));
    }
    text((int) indexes.get(0).x, indexes.get(0).y, startPos.y + (tickHeight * 2));
    text((int) indexes.get(indexes.size() - 1).x, indexes.get(indexes.size() - 1).y, startPos.y + (tickHeight * 2));
    fill(50);
    noStroke();
    ellipse(sCircle.x, sCircle.y, cSize.x, cSize.y);
  }


  boolean overButton() {
   // Checks if the mouse is within the circle
   // Source : https://processing.org/examples/button.html
   float disX = sCircle.x - mouseX; 
   float disY = sCircle.y - mouseY; 
   return (sqrt(sq(disX) + sq(disY))) < cSize.x/2;
  }
  
  boolean clickedCircle() {
   return overButton() && mousePressed; 
  }
}