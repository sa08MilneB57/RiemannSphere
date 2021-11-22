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
  String name(){return "Bessel-1st of order A: J_A(z)";}
  
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
  String name(){return "Binomial: z choose K";}
  
  
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
  String name(){return "Mobius: (Az + B) / (Cz + D)";}
  
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
