class ComplexSpinBox{
  final int detailA = 128;//longitude stripes, A stands for azimuth
  final int detailT = 63;//latitude stripes, T stands for Theta(Elevation)
  PGraphics display;
  color[] sphereLUT;
  PVector[] spherePoints;
  double azimuth,elevation;
  PVector screenPos,screenSize;
  boolean dragging = false;
  boolean snapping = false;
  ComplexSpinBox(Complex initialValue,ComplexColorMap cmap,float screenX,float screenY,int sizeX,int sizeY){
    screenPos = new PVector(screenX,screenY);
    screenSize = new PVector(sizeX,sizeY);
    display = createGraphics(sizeX,sizeY,P3D);
    setValue(initialValue);
    reColorise(cmap);
  }
  
  void reColorise(ComplexColorMap cmap){
    sphereLUT = new color[detailA*detailT];
    spherePoints = new PVector[detailA*detailT];
    final float dAzi = 2f*PI/(detailA-2);
    final float dTheta = PI / (detailT - 1);
    final float r = min(screenSize.x,screenSize.y)/3;
    for(int t=0;t<detailT;t++){
      for(int a=0;a<detailA;a++){
        float theta = dTheta*t - PI/2f;
        float azi = a*dAzi;
        int index = a + t*detailA;
        spherePoints[index] = new PVector(-r*sin(azi)*cos(theta),
                                          -r*sin(theta),
                                          r*cos(azi)*cos(theta));
        if(t == detailT/2){
          sphereLUT[index] = color(0);
        } else if(a == 0 || a == detailA/2 || a==detailA/4 || a==3*detailA/4){
          sphereLUT[index] = color(255);
        } else {
          double mag = Math.cos(theta) / (1-Math.sin(theta));
          if (t == 0){mag=0d;}
          sphereLUT[index] = cmap.map(fromPolar(mag,azi));
        }
      }
    }
    updateGraphics();
  }
  
  Complex value(){
    double mag = Math.cos(elevation) / (1-Math.sin(elevation));
    if (elevation == -Math.PI/2d){mag=0d;}
    return fromPolar(mag,azimuth);
  }
  
  void setValue(Complex newVal){
    double ZMAG2 = newVal.mag2();
    double ZMAG = Math.sqrt(ZMAG2);
    //calculate horizontal component
    double r = 2d*ZMAG / (ZMAG2 + 1d);
    double h = 1d - 2d/(ZMAG2 + 1d);
    azimuth = newVal.arg();
    elevation = Math.atan2(h,r);
  }
  
  boolean mousedOver(){
    final float relX = mouseX - screenPos.x;
    final float relY = mouseY - screenPos.y;
    return 0 < relX && relX < screenSize.x && 0<relY && relY < screenSize.y;
  }
  
  void updateGraphics(){
    display.beginDraw();
    display.noStroke();
      if(dragging){
        display.background(255,100);
      } else {
        display.background(0,100);
      }
      display.translate(display.width/2f,display.height/2f,0);
      display.rotateX(-(float)elevation);
      display.rotateY((float)azimuth);
      
      for(int t=0;t<detailT - 1;t++){
        display.beginShape(TRIANGLE_STRIP);
          for(int a=0;a<detailA - 1;a++){
            int index = a + t*detailA;
            int indexS = a + (t+1)*detailA;
            PVector p = spherePoints[index];
            PVector pS = spherePoints[indexS];
            display.fill(sphereLUT[index]);
            display.vertex(p.x,p.y,p.z);
            display.fill(sphereLUT[indexS]);
            display.vertex(pS.x,pS.y,pS.z);
          }
        display.endShape();
      }
    display.endDraw();
  }
  
  boolean show(){return show(false);}
  boolean show(boolean polarSnap){
    boolean valueChanged = false;
    if(dragging){
      if(!mousePressed){
        valueChanged = true;
        dragging = false;
        if(snapping){
          snapping = false;
          if (polarSnap){
            setValue(value().roundPolarHarmonic(TAU/8));
          } else {
            setValue(value().round());
          }
        }
      } else {
        azimuth   += (mouseX - pmouseX)*camSensitivity;
        elevation += (mouseY - pmouseY)*camSensitivity;
        azimuth = (azimuth%TAU + TAU) % TAU;
        elevation = Math.min(Math.max(elevation,-Math.PI/2d),Math.PI/2d);
      }
      updateGraphics();
    } else if (mousedOver()){
      if(mousePressed){
        dragging = true;
        if (mouseButton == RIGHT){
          snapping = true;
        }
      }
    }
    
    textSize(16);
    textAlign(CENTER,CENTER);
    image(display,screenPos.x,screenPos.y);
    fill(255);
    text(value().toString(),screenPos.x + screenSize.x/2f,screenPos.y + screenSize.y - 16);
    
    return valueChanged;
  }
}
