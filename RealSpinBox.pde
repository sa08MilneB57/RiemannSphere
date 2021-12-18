class IntegerSpinBox{
  final int detailA = 128;//longitude stripes, A stands for azimuth
  final int detailT = 63;//latitude stripes, T stands for Theta(Elevation)
  float buttonPadding,wideProportion,buttonHeight,buttonWidth,buttonLeft;
  PGraphics display;
  private boolean justClicked;
  private int _value;
  PVector screenPos,screenSize;
  IntegerSpinBox(int initialValue,float screenX,float screenY,int sizeX,int sizeY,float _wideProportion){
    screenPos = new PVector(screenX,screenY);
    screenSize = new PVector(sizeX,sizeY);
    display = createGraphics(sizeX,sizeY,P2D);
    setValue(initialValue);
    
    buttonPadding = 10;
    wideProportion = _wideProportion;
    buttonHeight = display.height/2- 2*buttonPadding;
    buttonWidth = wideProportion*display.width - 2*buttonPadding;
    buttonLeft = (1f-wideProportion)*display.width + buttonPadding;
    
    updateGraphics();
  }
  
  int value(){return _value;}
  
  void setValue(int newVal){_value = newVal;}
  
  boolean mousedOver(){
    final float relX = mouseX - screenPos.x;
    final float relY = mouseY - screenPos.y;
    return 0 < relX && relX < screenSize.x && 0<relY && relY < screenSize.y;
  }
  
  boolean mousedOverUp(){
    final float relX = mouseX - screenPos.x - buttonLeft;
    final float relY = mouseY - screenPos.y - buttonPadding;
    return 0 < relX && relX < buttonWidth && 0<relY && relY < buttonHeight;
  }
  boolean mousedOverDown(){
    final float relX = mouseX - screenPos.x - buttonLeft;
    final float relY = mouseY - screenPos.y - display.height/2 - buttonPadding;
    return 0 < relX && relX < buttonWidth && 0<relY && relY < buttonHeight;
  }
  
  void updateGraphics(){
    
    display.beginDraw();
    display.noStroke();
    display.background(100,100);
    
    //make buttons
    if(mousedOverUp()){
      display.fill(150,100,250);
    } else {
      display.fill(100,50,200);
    }
    display.rect(buttonLeft,10,buttonWidth,buttonHeight);
    if(mousedOverDown()){
      display.fill(150,100,250);
    } else {
      display.fill(100,50,200);
    }
    display.rect(buttonLeft,display.height/2 + buttonPadding,buttonWidth,buttonHeight);
    
    display.fill(255);
    display.textSize(buttonHeight);
    display.textAlign(CENTER,CENTER);
    display.text("+",buttonLeft + buttonWidth/2,buttonHeight/2 - buttonPadding/2);
    display.text("-",buttonLeft + buttonWidth/2,7*buttonHeight/4 - buttonPadding/2);
    
    //show value;
    display.textAlign(RIGHT,CENTER);
    display.textSize(display.height - 2*buttonPadding);
    display.text(_value,buttonLeft-buttonPadding,display.height/2 - buttonPadding);
      
    display.endDraw();
  }
  
  boolean show(){
    updateGraphics();
    boolean valueChanged = false;
    if(justClicked){
      if(!mousePressed){
        justClicked = false;
      }
    } else if (mousePressed){
      if(mousedOverUp()){
        justClicked = true;
        valueChanged = true;
        _value++;
      }
      if(mousedOverDown()){
        justClicked = true;
        valueChanged = true;
        _value--;
      }
    }
    
    image(display,screenPos.x,screenPos.y);
    
    return valueChanged;
  }
}
