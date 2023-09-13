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



ListMenu createFunctionList(InteractableFunction[] interactables,ComplexPlane plane){return createFunctionList(interactables,plane,18);}
ListMenu createFunctionList(InteractableFunction[] interactables,ComplexPlane plane,int txtSize){
  ListItem[] items = new ListItem[FUNCTIONS.length + interactables.length];
  
  final PVector increment = new PVector(0,1.2*txtSize);//how far it has to move per listItem
  PVector cursor = new PVector(width/2,height/2f - increment.y*items.length/2f);//the position of the first listItem, used to track position
  final float colrate = TAU/items.length;//huechange per item
  
  int maxwidth = 0; //find the maximum label length
  for(int i=0; i<FUNCTIONS.length;i++){maxwidth = max(maxwidth,FUNCTIONS[i].name().length());}
  PVector size = new PVector(maxwidth*txtSize,increment.y); //use maxwidth to set size of buttons, full sides of a rectangle
  
  
  //generate listitems
  for(int i=0; i<FUNCTIONS.length;i++){
    ComplexFunction func = FUNCTIONS[i];
    items[i] = new FunctionListItem(func,plane,cursor,size,i*colrate,0.7,0.7);
    cursor = cursor.add(increment);
  }
  for(int i=0; i<interactables.length;i++){
    InteractableFunction func = interactables[i];
    items[i + FUNCTIONS.length] = new InteractableFunctionListItem(func,plane,cursor,size,i*colrate,0.7,0.7);
    cursor = cursor.add(increment);
  }
  
  
  return new ListMenu(items,txtSize);
}
class FunctionListItem extends ListItem{
    ComplexFunction function;
    Functionable plane;
    FunctionListItem(ComplexFunction val,Functionable cplane,PVector p,PVector s,float H, float S, float L){
      super(val.menuName(),p,s,H,S,L);
      function = val;
      plane = cplane;
    }
    
    void onSelect(){
      normalMode();
      plane.applyFunction(function);
    }
    
    Object value(){return function;}
    
}

class InteractableFunctionListItem extends ListItem{
  InteractableFunction function;
  ComplexPlane plane;
  InteractableFunctionListItem(InteractableFunction val,ComplexPlane cplane,PVector p,PVector s,float H, float S, float L){
      super(val.menuName(),p,s,H,S,L);
      function = val;
      plane = cplane;
  }
  void onSelect(){
    interactableMode(function);
    function.onUpdate();
  }
    
  Object value(){return function;}
}
