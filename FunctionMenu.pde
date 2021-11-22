ComplexFunction[] FUNCTIONS = {
                            new CIdentity(),
                            new CReciprocal(),
                            
                            new CSquare(),
                            new CCube(),
                            new CSqrt(),
                            new CQuartish(),
                            
                            new CExp(),
                            new CLog(),
                            
                            new CSin(),
                            new CCos(),
                            new CTan(),
                            new CSinh(),
                            new CCosh(),
                            new CTanh(),
                            
                            new CASin(),
                            new CACos(),
                            new CATan(),
                            new CASinh(),
                            new CACosh(),
                            new CATanh(),
                            
                            new CBinet(),
                            new CMandel(25),
                            
                            new CGauss(),
                            new CGaussAbs(),
                            new CErf(0.125/8),
                            
                            new CZeta(30),
                            new CGamma(30),
                            new CReciprocalGamma(30)
                          };
InteractableFunction[] INTERACTABLES = {};


ListMenu createFunctionList(ComplexPlane plane){return createFunctionList(plane,18);}
ListMenu createFunctionList(ComplexPlane plane,int txtSize){
  ListItem[] items = new ListItem[FUNCTIONS.length + 3];
  
  final PVector increment = new PVector(0,1.2*txtSize);//how far it has to move per listItem
  PVector cursor = new PVector(width/2,height/2f - increment.y*items.length/2f);//the position of the first listItem, used to track position
  final float colrate = TAU/items.length;//huechange per item
  
  int maxwidth = 0; //find the maximum label length
  for(int i=0; i<FUNCTIONS.length;i++){maxwidth = max(maxwidth,FUNCTIONS[i].name().length());}
  PVector size = new PVector(maxwidth*txtSize/2f + 40,increment.y); //use maxwidth to set size of buttons, full sides of a rectangle
  
  //generate listitems
  for(int i=0; i<FUNCTIONS.length;i++){
    ComplexFunction func = FUNCTIONS[i];
    items[i] = new FunctionListItem(func,plane,cursor,size,i*colrate,0.7,0.7);
    cursor = cursor.add(increment);
  }
  items[FUNCTIONS.length] = new BinomialModeListItem(cursor,size,FUNCTIONS.length*colrate,0.7,0.7);
  cursor = cursor.add(increment);
  items[FUNCTIONS.length+1] = new MobiusModeListItem(cursor,size,(FUNCTIONS.length+1)*colrate,0.7,0.7);
  cursor = cursor.add(increment);
  items[FUNCTIONS.length+2] = new BesselModeListItem(cursor,size,(FUNCTIONS.length+1)*colrate,0.7,0.7);
  
  return new ListMenu(items,txtSize);
}
class FunctionListItem extends ListItem{
    ComplexFunction function;
    ComplexPlane plane;
    FunctionListItem(ComplexFunction val,ComplexPlane cplane,PVector p,PVector s,float H, float S, float L){
      super(val.name(),p,s,H,S,L);
      function = val;
      plane = cplane;
    }
    
    void onSelect(){
      normalMode();
      plane.applyFunction(function);
    }
    
    Object value(){return function;}
    
}

class BesselModeListItem extends ListItem{
  BesselModeListItem(PVector p,PVector s,float H, float S, float L){
      super("Bessel Function of the First Kind",p,s,H,S,L);
  }
  
  void onSelect() {besselMode();}
  Object value() {return null;}
  
}
class MobiusModeListItem extends ListItem{
  MobiusModeListItem(PVector p,PVector s,float H, float S, float L){
      super("Mobius Transform",p,s,H,S,L);
  }
  
  void onSelect() {mobiusMode();}
  Object value() {return null;}
  
}
class BinomialModeListItem extends ListItem{
  BinomialModeListItem(PVector p,PVector s,float H, float S, float L){
      super("Binomial (z choose k)",p,s,H,S,L);
  }
  
  void onSelect() {binomialMode();}
  Object value() {return null;}
  
}
