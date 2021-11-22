int hermiteOrder = 0;
final int MENUTEXTSIZE = 20;
final int SPINBOXSIZE = 360;

ComplexColorMap[] cmaps;
MobiusTransform mobius;
Binomial binomial;
BesselFirst bessel1;
ListMenu flist;

int activeCmap = 0;
ComplexPlane plane;
final float sphereRadius = 100;
float spheriness = 0f;
final int DETAIL = 521;
final double RANGE = 20;
float camAzimuth = 0;
float camElevation = 0;
float camDistance = sphereRadius;
float startDistance;
final float camSensitivity = 1f/100f;
float heightScale = sphereRadius/10f;
int colorScale = 1;
float oldHeightScale;
int turningA = 0;
int turningE = 0;
int switchingM = 0;
color hudBack = color(200,100,255,50);
color hudFront = color(255);
boolean showFuncMenu = false;
boolean binomialMode = false;
boolean mobiusMode = false;
boolean bessel1Mode = false;
PFont fixed,thin;

void setup(){
  fullScreen(P3D);
  //size(480,480,P3D);
  hint(DISABLE_OPENGL_ERRORS);
  
  
  plane = new ComplexPlane(RANGE,DETAIL);
  plane.applyFunction(new CIdentity());
  refreshColormap();
  binomial = new Binomial(plane,cmaps[activeCmap],SPINBOXSIZE);
  mobius = new MobiusTransform(plane,cmaps[activeCmap],SPINBOXSIZE);
  bessel1 = new BesselFirst(plane,cmaps[activeCmap],SPINBOXSIZE);
  
  startDistance = (height/2.0) / tan(PI/6.0);
  
  fixed = createFont("Consolas",28);
  thin = createFont("Calibri Light",16);
  flist = createFunctionList(plane,MENUTEXTSIZE);
}

void draw(){
  background(15,15,25);
  
  pushMatrix();
    translate(width/2,height/2,-camDistance);
    rotateX(camElevation);
    rotateY(camAzimuth);
    
    plane.show(sphereRadius,heightScale,spheriness,cmaps[activeCmap]);
    if(spheriness != 0){  
      strokeWeight(spheriness*2);
      stroke(255,0,0,spheriness*255);
      line(-width,0,0,width,0,0);
      stroke(0,255,0,spheriness*255);
      line(0,-width,0,0,width,0);
      stroke(0,0,255,spheriness*255);
      line(0,0,-width,0,0,width);
    }
  popMatrix();
  
  //HUD
  hint(DISABLE_DEPTH_TEST);
  textFont(fixed);
  noStroke();
  textAlign(LEFT);
  textSize(28);
  rectMode(CORNER);
  fill(hudBack);
  rect(5,10,plane.currentFunction.name().length() * 20 + 20,40);
  fill(hudFront);
  text(plane.currentFunction.name(),20,40);
  fill(hudBack);
  rect(5,60,160,40);
  fill(hudFront);
  text("GridScale:" + ((colorScale>0)?colorScale:"1/" + (-colorScale)),10,90);
  
  if(showFuncMenu){
    if(flist.show()){//if an item is selected
      showFuncMenu = false;
    }
  }
  textFont(thin);
  if(binomialMode){
    binomial.show(activeCmap == 2);
  }
  if (mobiusMode){
    mobius.show(activeCmap == 2);
  }
  if (bessel1Mode){
    bessel1.show(activeCmap == 2);
  }
  
  hint(ENABLE_DEPTH_TEST);
  
  //apply currently active smooth changes like camera and ball<>plane
  if (turningA != 0){
    camAzimuth += turningA*0.1;
    camAzimuth = (camAzimuth%TAU + TAU) % TAU;
  }
  if (turningE != 0){
    camElevation += turningE*0.125;
    camElevation = constrain(camElevation,-PI/2f,PI/2f);
  }
  if (switchingM != 0){
    spheriness += switchingM * 0.125/4;
    if(spheriness < 0){
       spheriness = 0;
       switchingM = 0;
    } else if (spheriness > 1){
       spheriness = 1;
       switchingM = 0;
    }
  }
}

void refreshColormap(){
  float scaling = (colorScale > 0)? colorScale : -1f/colorScale;
  cmaps = new ComplexColorMap[4];
  cmaps[0] = new ArgandToHueBright(scaling); 
  cmaps[1] = new ArgandGrid(scaling,scaling);
  cmaps[2] = new ArgandPolar(scaling,scaling,8);
  cmaps[3] = new ArgandToYCoCg(scaling);
}

void normalMode(){
  mobiusMode = false;
  binomialMode = false;
  bessel1Mode = false;
}

void binomialMode(){
  mobiusMode = false;
  binomialMode = true;
  bessel1Mode = false;
  binomial.onUpdate();
}
void mobiusMode(){
  mobiusMode = true;
  binomialMode = false;
  bessel1Mode = false;
  mobius.onUpdate();
}
void besselMode(){
  bessel1Mode = true;
  mobiusMode = false;
  binomialMode = false;
  bessel1.onUpdate();
}

void mouseWheel(MouseEvent e){
  camDistance += 10f*e.getCount();
  //camDistance = constrain(camDistance,-startDistance + sphereRadius, 2 * sphereRadius);
  camDistance = constrain(camDistance,-startDistance + sphereRadius, sphereRadius*1000);
}

void mouseDragged(){
  if((binomialMode && binomial.usingMouse()) || (mobiusMode && mobius.usingMouse()) || (bessel1Mode && bessel1.usingMouse())){
    //prevents mouse from controlling camera while using a spinbox
    return;
  }
  camAzimuth   += (mouseX - pmouseX)*camSensitivity;
  camElevation -= (mouseY - pmouseY)*camSensitivity;
  camAzimuth = (camAzimuth%TAU + TAU) % TAU;
  camElevation = constrain(camElevation,-PI/2f,PI/2f);
  
}

void keyPressed(){
  if (key == CODED){
    if (keyCode == UP){
      turningE = -1;
      return;
    } else if (keyCode == DOWN){
      turningE = 1;
      return;
    } else if (keyCode == LEFT){
      turningA = 1;
      return;
    } else if (keyCode == RIGHT){
      turningA = -1;
      return;
    }
  }
  switch(key){
    case '\t':
      showFuncMenu = !showFuncMenu;
      break;
    case '-':
      hermiteOrder--;
      if(hermiteOrder < 0){hermiteOrder = 0;}
      plane.applyFunction(new CHermiteFunction(hermiteOrder));
      break;
    case '=':
      hermiteOrder++;
      plane.applyFunction(new CHermiteFunction(hermiteOrder));
      break;
    case '[':
      heightScale *= 0.8;
      if(heightScale < 1){heightScale = 1;}
      break;
    case ']':
      heightScale *= 1.25;
      break;
    case '{':
      colorScale--;
      if(colorScale == 0){colorScale = -2;}
      refreshColormap();
      binomial.reColorise(cmaps[activeCmap]);
      mobius.reColorise(cmaps[activeCmap]);
      bessel1.reColorise(cmaps[activeCmap]);
      break;
    case '}':
      colorScale++;
      if(colorScale == -1){colorScale = 1;}
      refreshColormap();
      binomial.reColorise(cmaps[activeCmap]);
      mobius.reColorise(cmaps[activeCmap]);
      bessel1.reColorise(cmaps[activeCmap]);
      break;
    case '\'':
      if(heightScale==0){
        heightScale = oldHeightScale;
      } else {
        oldHeightScale = heightScale;
        heightScale = 0;
      }
      break;
    case 'P':
    case 'p':
      if (switchingM == 1){
        switchingM = -1;
      } else if (switchingM == -1){
        switchingM = 1;
      } else if (spheriness == 0){
        switchingM = 1;
      } else if (spheriness == 1){
        switchingM = -1;
      }
      break;
    case '#':
      activeCmap = (activeCmap+1) % cmaps.length;
      binomial.reColorise(cmaps[activeCmap]);
      mobius.reColorise(cmaps[activeCmap]);
      bessel1.reColorise(cmaps[activeCmap]);
      break;
    case '~':
      activeCmap = (activeCmap-1 + cmaps.length) % cmaps.length;
      binomial.reColorise(cmaps[activeCmap]);
      mobius.reColorise(cmaps[activeCmap]);
      bessel1.reColorise(cmaps[activeCmap]);
      break;
  }
}

void keyReleased(){
  if (key == CODED){
      if (keyCode == UP || keyCode == DOWN){
        turningE = 0;
        return;
      } else if (keyCode == LEFT || keyCode == RIGHT){
        turningA = 0;
        return;
      }
    }
}
