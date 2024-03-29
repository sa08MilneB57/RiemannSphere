//Feel free to change variables in this block, I'm planning on adding a settings dialogue for most of them
final int MENUTEXTSIZE = 16;//default 20
final int DETAIL = 521;
final double RANGE = 16;
final float sphereRadius = 100;
final float camSensitivity = 1f/100f;
final color hudBack = color(200, 100, 255, 50);
final color hudFront = color(255);


ComplexColorMap[] cmaps;
InteractableFunction[] interactables;
InteractableFunction activeFunc;
ListMenu flist;

int activeCmap = 0;
int absReIm = 1;
ComplexPlane plane;
int SPINBOXSIZE;
float spheriness = 0f;
float camAzimuth = 0;
float camElevation = 0;
float camDistance = sphereRadius;
float startDistance;
float heightScale = sphereRadius/10f;
int colorScale = 1;
float oldHeightScale;
int turningA = 0;
int turningE = 0;
int switchingM = 0;
boolean showFuncMenu = false;
boolean interactableMode = false;
PFont fixed, thin;

void setup() {
  fullScreen(P3D);
  //size(1000,800,P3D);
  hint(DISABLE_OPENGL_ERRORS);

  SPINBOXSIZE = min(width, height) / 5;
  plane = new ComplexPlane(RANGE, DETAIL);
  plane.applyFunction(new CIdentity());
  refreshColormap();
  interactables = new InteractableFunction[7];
  interactables[0] = new Binomial(plane, cmaps[activeCmap], SPINBOXSIZE);
  interactables[1] = new MobiusTransform(plane, cmaps[activeCmap], SPINBOXSIZE);
  interactables[2] = new ArbitraryPolynomial(plane, cmaps[activeCmap], SPINBOXSIZE);
  interactables[3] = new ArbitraryPolynomialRoots(plane, cmaps[activeCmap], SPINBOXSIZE);
  interactables[4] = new AtomicSingularInnerFunction(plane, SPINBOXSIZE);
  interactables[5] = new HermiteFunction(plane, SPINBOXSIZE);
  interactables[6] = new BinetLike(plane, cmaps[activeCmap], SPINBOXSIZE);
  //interactables[7] = new BesselFirst(plane,cmaps[activeCmap],SPINBOXSIZE);

  startDistance = (height/2.0) / tan(PI/6.0);

  fixed = createFont("Consolas", 28);
  thin = createFont("Calibri Light", 16);
  flist = createFunctionList(interactables, plane, MENUTEXTSIZE);
}

void draw() {
  background(15, 15, 25);

  pushMatrix();
  translate(width/2, height/2, -camDistance);
  rotateX(camElevation);
  rotateY(camAzimuth);

  plane.show(sphereRadius, heightScale, spheriness, cmaps[activeCmap],absReIm);
  if (spheriness != 0) {
    pushStyle();
      strokeWeight(spheriness*2);
      stroke(255, 0, 0, spheriness*255);
      line(-width, 0, 0, width, 0, 0);
      stroke(0, 255, 0, spheriness*255);
      line(0, -width, 0, 0, width, 0);
      stroke(0, 0, 255, spheriness*255);
      line(0, 0, -width, 0, 0, width);
    popStyle();
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
  rect(5, 10, plane.currentFunction.name().length() * 22 + 20, 40);
  fill(hudFront);
  text(plane.currentFunction.name(), 20, 40);
  fill(hudBack);
  rect(5, 60, 240, 40);
  fill(hudFront);
  text("GridScale:" + ((colorScale>0)?colorScale:"1/" + (-colorScale)), 10, 90);
  text("HeightMode:" + absReIm, 10, 140);

  if (showFuncMenu) {
    if (flist.show()) {//if an item is selected
      showFuncMenu = false;
    }
  }
  textFont(thin);
  if (interactableMode) {
    activeFunc.show(activeCmap == 2);
  }


  hint(ENABLE_DEPTH_TEST);

  //apply currently active smooth changes like camera and ball<>plane
  if (turningA != 0) {
    camAzimuth += turningA*0.1;
    camAzimuth = (camAzimuth%TAU + TAU) % TAU;
  }
  if (turningE != 0) {
    camElevation += turningE*0.125;
    camElevation = constrain(camElevation, -PI/2f, PI/2f);
  }
  if (switchingM != 0) {
    spheriness += switchingM * 0.125/4;
    if (spheriness < 0) {
      spheriness = 0;
      switchingM = 0;
    } else if (spheriness > 1) {
      spheriness = 1;
      switchingM = 0;
    }
  }
}

void refreshColormap() {
  float scaling = (colorScale > 0)? colorScale : -1f/colorScale;
  cmaps = new ComplexColorMap[8];
  cmaps[0] = new ArgandToHueBright(scaling); 
  cmaps[1] = new ArgandGrid(scaling, scaling);
  cmaps[2] = new ArgandPolar(scaling, scaling, 8);
  cmaps[3] = new ArgandToYCoCg(scaling);
  cmaps[4] = new ArgandStripedRB(scaling);
  cmaps[5] = new ArgandStripedLogRB(2.718);
  cmaps[6] = new ArgandStripedPolar(scaling,8);
  cmaps[7] = new ArgandStripedLogPolar(2.718,8);
}

void normalMode() {
  interactableMode = false;
}

void interactableMode(InteractableFunction function) {
  interactableMode = true;
  activeFunc = function;
  activeFunc.reColorise(cmaps[activeCmap]);
}

void mouseWheel(MouseEvent e) {
  camDistance += 10f*e.getCount();
  //camDistance = constrain(camDistance,-startDistance + sphereRadius, 2 * sphereRadius);
  camDistance = constrain(camDistance, -startDistance + sphereRadius, sphereRadius*1000);
}

void mouseDragged() {
  if ((interactableMode && activeFunc.usingMouse())) {
    //prevents mouse from controlling camera while using a spinbox
    return;
  }
  camAzimuth   += (mouseX - pmouseX)*camSensitivity;
  camElevation -= (mouseY - pmouseY)*camSensitivity;
  camAzimuth = (camAzimuth%TAU + TAU) % TAU;
  camElevation = constrain(camElevation, -PI/2f, PI/2f);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      turningE = -1;
      return;
    } else if (keyCode == DOWN) {
      turningE = 1;
      return;
    } else if (keyCode == LEFT) {
      turningA = 1;
      return;
    } else if (keyCode == RIGHT) {
      turningA = -1;
      return;
    }
  }
  switch(key) {
  case '\t':
    showFuncMenu = !showFuncMenu;
    break;
  case '[':
    heightScale *= 0.8;
    if (heightScale < 1) {
      heightScale = 1;
    }
    break;
  case ']':
    heightScale *= 1.25;
    break;
  case '{':
    colorScale--;
    if (colorScale == 0) {
      colorScale = -2;
    }
    refreshColormap();
    if (interactableMode) {
      activeFunc.reColorise(cmaps[activeCmap]);
    }
    break;
  case '}':
    colorScale++;
    if (colorScale == -1) {
      colorScale = 1;
    }
    refreshColormap();
    if (interactableMode) {
      activeFunc.reColorise(cmaps[activeCmap]);
    }
    break;
  case '\'':// '
    absReIm = (absReIm + 1)%4;
    break;
  case '@':// SHIFT + '
    absReIm = (absReIm - 1 + 4)%4;
    break;
  case 'P':
  case 'p':
    if (switchingM == 1) {
      switchingM = -1;
    } else if (switchingM == -1) {
      switchingM = 1;
    } else if (spheriness == 0) {
      switchingM = 1;
    } else if (spheriness == 1) {
      switchingM = -1;
    }
    break;
  case '#':
    activeCmap = (activeCmap+1) % cmaps.length;
    if (interactableMode) {
      activeFunc.reColorise(cmaps[activeCmap]);
    }
    break;
  case '~':
    activeCmap = (activeCmap-1 + cmaps.length) % cmaps.length;
    if (interactableMode) {
      activeFunc.reColorise(cmaps[activeCmap]);
    }
    break;
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP || keyCode == DOWN) {
      turningE = 0;
      return;
    } else if (keyCode == LEFT || keyCode == RIGHT) {
      turningA = 0;
      return;
    }
  }
}
