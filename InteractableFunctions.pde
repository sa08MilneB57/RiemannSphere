abstract class InteractableFunction implements ComplexFunction{
  ComplexPlane plane;
  
  InteractableFunction(ComplexPlane _plane){plane = _plane;}
  
  abstract void show(boolean alt); //show functions should also handle interactivity and apply onUpdate();
  abstract boolean usingMouse();
  abstract void reColorise(ComplexColorMap cmap);
  void onUpdate(){
    plane.applyFunction(this);
  }
}

class BinetLike extends InteractableFunction{
  ComplexSpinBox root1, root2;
  BinetLike(ComplexPlane _plane, ComplexColorMap cmap, int spinBoxSize){
    super(_plane);
    root1 = new ComplexSpinBox(new Complex(1,0),cmap, width/2f - spinBoxSize ,height-spinBoxSize - 5,spinBoxSize,spinBoxSize);
    root2 = new ComplexSpinBox(new Complex(-1,0),cmap, width/2f + spinBoxSize ,height-spinBoxSize - 5,spinBoxSize,spinBoxSize);
  }
  String name(){return "Generalised Binet-Style Function";}
  String menuName(){return "Generalised Binet-Style Function";}
  Complex f(Complex z){
    return root1.value().raiseTo(z).sub(root2.value().raiseTo(z));
  }
  
  boolean usingMouse(){return root1.dragging || root2.dragging;}
  
  void reColorise(ComplexColorMap cmap){
    root1.reColorise(cmap);
    root2.reColorise(cmap);
  }
  
  void show(boolean polarSnap){
    boolean updated = root1.show(polarSnap) || root2.show(polarSnap);
    if(updated){onUpdate();}
    text("Root 1",root1.screenPos.x + root1.screenSize.x/2 , root1.screenPos.y + 16);
    text("Root 2",root2.screenPos.x + root2.screenSize.x/2 , root2.screenPos.y + 16);
  }
}

class ArbitraryPolynomial extends InteractableFunction{
  CPolynomial P;
  IntegerSpinBox order;
  ComplexSpinBox[] coefficients;
  ArbitraryPolynomial(ComplexPlane _plane, ComplexColorMap cmap,int spinBoxSize){
    super(_plane);
    order = new IntegerSpinBox(2,(width - spinBoxSize)/2 ,48 ,spinBoxSize,spinBoxSize/2,0.3);
    onUpdateOrder(cmap);
  }
  
  String name(){return P.name();}
  String menuName(){return "Polynomial from Coefficients";}
  Complex f(Complex z){return P.f(z);}
  
  boolean usingMouse(){
    boolean out = false;
    for(ComplexSpinBox spinner : coefficients){
      out = out || spinner.dragging;
    }
    return out;
  }
  
  void reColorise(ComplexColorMap cmap){
    for(ComplexSpinBox spinner : coefficients){
      spinner.reColorise(cmap);
    }
  }
  
  @Override
  void onUpdate(){//this function is run when the order or the coefficients are updated
    Complex[] coefs = new Complex[coefficients.length];
    for (int i=0; i<= order.value(); i++){
      coefs[i] = coefficients[i].value();
    }
    P = new CPolynomial(coefs);
    super.onUpdate();
  }
  
  void onUpdateOrder(ComplexColorMap cmap){ //this function is ran when the order is updated
    if(order.value() <0){order.setValue(0);}
    float horizontalSpacing = width/(order.value() + 3f);//+1 because the order is one less than the length, plus 2 for either end of the screen
    int spinBoxSize = (int)min(height/5 , horizontalSpacing);
    if (coefficients == null){//if there is no spinners
      coefficients = new ComplexSpinBox[order.value() + 1];
      for (int i=0; i<= order.value(); i++){
        coefficients[i] = new ComplexSpinBox(new Complex(1,0),cmap,horizontalSpacing * (i+1) ,height-spinBoxSize - 5,spinBoxSize,spinBoxSize);
      }
    } else if (order.value() + 1 < coefficients.length){//when the order decreases
      ComplexSpinBox[] newSpinners = new ComplexSpinBox[order.value() + 1];
      for (int i=0; i<= order.value(); i++){
        newSpinners[i] = new ComplexSpinBox(coefficients[i].value(),cmap,horizontalSpacing * (i+1) ,height-spinBoxSize - 5,spinBoxSize,spinBoxSize);
      }
      coefficients = newSpinners;
    } else if (order.value() + 1 > coefficients.length){//when the order increases
      ComplexSpinBox[] newSpinners = new ComplexSpinBox[order.value() + 1];
      for (int i=0; i< coefficients.length; i++){
        newSpinners[i] = new ComplexSpinBox(coefficients[i].value(),cmap,horizontalSpacing * (i+1) ,height-spinBoxSize - 5,spinBoxSize,spinBoxSize);
      }
      for (int i=coefficients.length; i<= order.value(); i++){
        newSpinners[i] = new ComplexSpinBox(new Complex(1,0),cmap,horizontalSpacing * (i+1) ,height-spinBoxSize - 5,spinBoxSize,spinBoxSize);
      }
      coefficients = newSpinners;
    }
  }
  void show(boolean polarSnap){
    order.show();
    if (order.justClicked){
      onUpdateOrder(cmaps[activeCmap]);
      onUpdate();
    }
    boolean complexUpdated = false;
    for (int i=0; i<coefficients.length; i++){
      ComplexSpinBox spinner = coefficients[i];
      complexUpdated = complexUpdated || spinner.show(polarSnap);
      text(i,spinner.screenPos.x + spinner.screenSize.x/2 , spinner.screenPos.y + 16);
    }
    if( complexUpdated ){
      onUpdate();
    }
  }
}

class ArbitraryPolynomialRoots extends InteractableFunction{
  CPolynomial P;
  IntegerSpinBox rootNum;
  ComplexSpinBox[] roots;
  ArbitraryPolynomialRoots(ComplexPlane _plane, ComplexColorMap cmap,int spinBoxSize){
    super(_plane);
    rootNum = new IntegerSpinBox(4,(width - spinBoxSize)/2 ,48 ,spinBoxSize,spinBoxSize/2,0.3);
    onUpdateOrder(cmap);
  }
  
  String name(){
    String[] monos = new String[rootNum.value()];
    for(int i=0;i<rootNum.value();i++){
      monos[i] = "(z-" + roots[i].value() + ")";
    }
    String out = "";
    for(int i=0;i<rootNum.value()-1;i++){
      out += monos[i] + " * ";
    }
    out += monos[rootNum.value() - 1];
    return out;
  }
  String menuName(){return "Polynomial from Roots";}
  Complex f(Complex z){return P.f(z);}
  
  boolean usingMouse(){
    boolean out = false;
    for(ComplexSpinBox spinner : roots){
      out = out || spinner.dragging;
    }
    return out;
  }
  
  void reColorise(ComplexColorMap cmap){
    for(ComplexSpinBox spinner : roots){
      spinner.reColorise(cmap);
    }
  }
  
  @Override
  void onUpdate(){//this function is run when the order or the coefficients are updated
    Complex[] rootVals = new Complex[roots.length];
    for (int i=0; i< rootNum.value(); i++){
      rootVals[i] = roots[i].value();
    }
    P = fromRoots(rootVals);
    super.onUpdate();
  }
  
  void onUpdateOrder(ComplexColorMap cmap){ //this function is ran when the order is updated
    if(rootNum.value() <= 0){rootNum.setValue(1);}
    float horizontalSpacing = width/(rootNum.value() + 2f);//plus 2 for either end of the screen
    int spinBoxSize = (int)min(height/5 , horizontalSpacing);
    if (roots == null){//if there is no spinners
      roots = new ComplexSpinBox[4];
      roots[0] = new ComplexSpinBox(new Complex(1,0),cmap,horizontalSpacing * (0+1) ,height-spinBoxSize - 5,spinBoxSize,spinBoxSize);
      roots[1] = new ComplexSpinBox(new Complex(-1,0),cmap,horizontalSpacing * (1+1) ,height-spinBoxSize - 5,spinBoxSize,spinBoxSize);
      roots[2] = new ComplexSpinBox(new Complex(0,1),cmap,horizontalSpacing * (2+1) ,height-spinBoxSize - 5,spinBoxSize,spinBoxSize);
      roots[3] = new ComplexSpinBox(new Complex(0,-1),cmap,horizontalSpacing * (3+1) ,height-spinBoxSize - 5,spinBoxSize,spinBoxSize);
    } else if (rootNum.value() < roots.length){//when the order decreases
      ComplexSpinBox[] newSpinners = new ComplexSpinBox[rootNum.value()];
      for (int i=0; i< rootNum.value(); i++){
        newSpinners[i] = new ComplexSpinBox(roots[i].value(),cmap,horizontalSpacing * (i+1) ,height-spinBoxSize - 5,spinBoxSize,spinBoxSize);
      }
      roots = newSpinners;
    } else if (rootNum.value() > roots.length){//when the order increases
      ComplexSpinBox[] newSpinners = new ComplexSpinBox[rootNum.value()];
      for (int i=0; i< roots.length; i++){
        newSpinners[i] = new ComplexSpinBox(roots[i].value(),cmap,horizontalSpacing * (i+1) ,height-spinBoxSize - 5,spinBoxSize,spinBoxSize);
      }
      for (int i=roots.length; i< rootNum.value(); i++){
        newSpinners[i] = new ComplexSpinBox(new Complex(1,0),cmap,horizontalSpacing * (i+1) ,height-spinBoxSize - 5,spinBoxSize,spinBoxSize);
      }
      roots = newSpinners;
    }
  }
  void show(boolean polarSnap){
    rootNum.show();
    if (rootNum.justClicked){
      onUpdateOrder(cmaps[activeCmap]);
      onUpdate();
    }
    boolean complexUpdated = false;
    for (int i=0; i<roots.length; i++){
      ComplexSpinBox spinner = roots[i];
      complexUpdated = complexUpdated || spinner.show(polarSnap);
    }
    if( complexUpdated ){
      onUpdate();
    }
  }
}

class BesselFirst extends InteractableFunction{
  Complex[] coefs,pwrs;
  ComplexSpinBox order;
  final int accuracy = 30;
  ComplexFunction rgamma;
  BesselFirst(ComplexPlane _plane,ComplexColorMap cmap,int spinBoxSize){
    super(_plane);
    rgamma = new CReciprocalGamma(50);
    order = new ComplexSpinBox(new Complex(1,0),cmap,(width-spinBoxSize)/2 ,height-spinBoxSize - 5,spinBoxSize,spinBoxSize);
    updateTerms();
  }
  String name(){return "J_(" + order.value() + ")(z)";}
  String menuName(){return "(WIP) Bessel-1st of order A: J_A(z)";}
  
  Complex f(Complex z){
    Complex sum = new Complex(0,0);
    for(int m=0; m<accuracy; m++){
      sum = sum.add(  z.raiseTo(pwrs[m]).mult(coefs[m])  );
    }
    return sum;
  }
  
  boolean usingMouse(){
    return order.dragging;
  }
  
  void show(boolean polarSnap){
    final boolean A = order.show(polarSnap);
    text("alpha",order.screenPos.x + order.screenSize.x/2 , order.screenPos.y + 16);
    if( A ){
      onUpdate();
    }
  }
  void reColorise(ComplexColorMap cmap){
    order.reColorise(cmap);
  }
  
  void updateTerms(){
    coefs = new Complex[accuracy];
    pwrs = new Complex[accuracy];
    final Complex alpha = order.value();
    final Complex TWO = new Complex(2,0);
    for(int m=0; m<accuracy; m++){
      Complex M = new Complex(m,0);
      pwrs[m] = M.mult(2).add(alpha);
      
      Complex sign = new Complex((m%2 == 0)?1:-1 ,0);// (-1)^m
      Complex rGammaPart = rgamma.f(M.add(alpha).add(1)); // 1/Gamma(m+a+1)
      final double rFactM = 1d / factorial(m); // 1/m!
      final Complex rPowPart = TWO.raiseTo(alpha.add(m).neg()); // 2^-(m+a)
      coefs[m] = sign.mult( rGammaPart ).mult(rFactM).mult(rPowPart);
    }
  }
  
  @Override
  void onUpdate(){
    updateTerms();
    super.onUpdate();
  }
  
}


class Binomial extends InteractableFunction{
  final int accuracy = 30;
  ComplexSpinBox k;
  ComplexFunction rGamma;
  Binomial(ComplexPlane _plane,ComplexColorMap cmap,int spinBoxSize){
    super(_plane);
    k = new ComplexSpinBox(new Complex(1,0),cmap,(width-spinBoxSize)/2 ,height-spinBoxSize - 5,spinBoxSize,spinBoxSize);
    rGamma = new CReciprocalGamma(accuracy);
  }
  String name(){return "Binomial: z choose " + k.value();}
  String menuName(){return "Binomial: z choose K";}
  
  
  Complex f(Complex z){
    final Complex K = k.value();
    final Complex gammaN  =  rGamma.f(z.add(1)).reciprocal();
    final Complex gammaD1 =  rGamma.f(K.add(1));
    final Complex gammaD2 =  rGamma.f(z.sub(K).add(1));
    return gammaN.mult(gammaD1).mult(gammaD2);
  }
  
  boolean usingMouse(){
    return k.dragging;
  }
  
  void show(boolean polarSnap){
    final boolean K = k.show(polarSnap);
    text("k",k.screenPos.x + k.screenSize.x/2 , k.screenPos.y + 16);
    if( K ){
      onUpdate();
    }
  }
  void reColorise(ComplexColorMap cmap){
    k.reColorise(cmap);
  }
}

class AtomicSingularInnerFunction extends InteractableFunction{
  IntegerSpinBox order;
  Complex[] roots;
  AtomicSingularInnerFunction(ComplexPlane _plane,int spinBoxSize){
    super(_plane);
    order = new IntegerSpinBox(5,(width - spinBoxSize)/2 ,height-spinBoxSize/2 - 5,spinBoxSize,spinBoxSize/2,0.3);
  }
  String name(){
    String rootText = "exp(2iπ/" + order.value() + ")";
    return "Product n=1 to " + Integer.toString(order.value()) + " of [ exp(  (z +" + rootText + "^n) / (z -" + rootText + "^n)  ) ]";
  }
  String menuName(){return "Atomic Singular Inner Function";}
  Complex f(Complex z){
    Complex out = new Complex(1,0);
    for (Complex root : roots){
      Complex term = z.add(root).divBy( z.sub(root) ).exp();
      out = out.mult(term);
    }
    return out;
  }
  
  @Override
  void onUpdate(){
    if(order.value() <0){order.setValue(0);}
    roots = new Complex[order.value()];
    for (int n=0; n<order.value(); n++){
      roots[n] = fromPolar(n*2d*Math.PI/order.value());
    }
    super.onUpdate();
  }
  
  boolean usingMouse(){
    return order.justClicked;
  }
  
  void show(boolean polarSnap){
    final boolean clicked = order.show();
    if( clicked ){
      onUpdate();
    }
  }
  void reColorise(ComplexColorMap cmap){}
  
}

class HermiteFunction extends InteractableFunction{
  IntegerSpinBox order;
  ComplexFunction H,G,C,F;
  HermiteFunction(ComplexPlane _plane,int spinBoxSize){
    super(_plane);
    order = new IntegerSpinBox(3,(width - spinBoxSize)/2 ,height-spinBoxSize/2 - 5,spinBoxSize,spinBoxSize/2,0.3);    
    refreshFunctions();
  }
  String name(){return F.name();}
  String menuName(){return "Hermite Functions";}
  Complex f(Complex z){return F.f(z);}
  
  void refreshFunctions(){
    if(order.value() <0){order.setValue(0);}
    double constant = 1d/Math.sqrt(Math.scalb( Math.sqrt(Math.PI)*factorial(order.value()) , order.value()) );
    H = new CHermitePolynomial(order.value());
    G = new ComposeWrapper(new CGaussAbs(),new CScale(new Complex(Math.sqrt(2),0)));//exp(|z|^2 / 2)
    C = new CConstant(new Complex(constant,0));
    ComplexFunction[] factors = {C,G,H};
    F = new ProductWrapper(factors);
  }
  
  @Override
  void onUpdate(){
    refreshFunctions();
    super.onUpdate();
  }
  
  boolean usingMouse(){
    return order.justClicked;
  }
  
  void show(boolean polarSnap){
    final boolean clicked = order.show();
    if( clicked ){ onUpdate(); }
  }
  void reColorise(ComplexColorMap cmap){}
  
}



class MobiusTransform extends InteractableFunction{
  ComplexSpinBox a,b,c,d;
  MobiusTransform(ComplexPlane _plane,ComplexColorMap cmap,int spinBoxSize){
    super(_plane);
    final float increment = width/5f;
    final float yPos = height - spinBoxSize - 10;
    float cursor = increment - spinBoxSize/2f;
    a = new ComplexSpinBox(new Complex(1,0),  cmap,  cursor,yPos,  spinBoxSize,spinBoxSize);
    cursor += increment;
    b = new ComplexSpinBox(new Complex(0,0),  cmap,  cursor,yPos,  spinBoxSize,spinBoxSize);
    cursor += increment;
    c = new ComplexSpinBox(new Complex(1,0),  cmap,  cursor,yPos,  spinBoxSize,spinBoxSize);
    cursor += increment;
    d = new ComplexSpinBox(new Complex(1,0),  cmap,  cursor,yPos,  spinBoxSize,spinBoxSize);
    cursor += increment;
  }
  String name(){return "(Az + B) / (Cz + D)";}
  String menuName(){return "Mobius Transformations";}
  
  Complex f(Complex z){return ( z.mult(a.value()).add(b.value()) 
                       ).divBy( z.mult(c.value()).add(d.value()) );}
  
  void show(boolean polarSnap){
    final boolean A = a.show(polarSnap);
    text("A",a.screenPos.x + a.screenSize.x/2 , a.screenPos.y + 16);
    final boolean B = b.show(polarSnap);
    text("B",b.screenPos.x + b.screenSize.x/2 , b.screenPos.y + 16);
    final boolean C = c.show(polarSnap);
    text("C",c.screenPos.x + c.screenSize.x/2 , c.screenPos.y + 16);
    final boolean D = d.show(polarSnap);
    text("D",d.screenPos.x + d.screenSize.x/2 , d.screenPos.y + 16);
    if( A || B || C || D ){
      onUpdate();
    }
  }
  
  boolean usingMouse(){
    return a.dragging ||b.dragging ||c.dragging ||d.dragging;
  }
  
  void reColorise(ComplexColorMap cmap){
    a.reColorise(cmap);
    b.reColorise(cmap);
    c.reColorise(cmap);
    d.reColorise(cmap);
  }
}
