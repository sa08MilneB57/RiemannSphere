final double degrees = Math.PI/180d;



Complex fromPolar(double arg){return fromPolar(1d,arg);}
Complex fromPolar(double mag,double arg){
  //allows definition of complex numbers by polar representation
  return new Complex(mag*Math.cos(arg),mag*Math.sin(arg));
}

Complex lerp(Complex a, Complex b, double t){return a.add(b.sub(a).mult(t));}
Complex lerp(Complex a, Complex b, Complex t){return a.add(b.sub(a).mult(t));}

Complex[] linspaceC(double low, double high, int len){return linspaceC(new Complex(low,0),new Complex(high,0),len);}
Complex[] linspaceC(Complex low, Complex high,int len) {
    Complex[] arr = new Complex[len];
    Complex step = high.sub(low).divBy(len-1);
    for (int i = 0; i < len; i++) {arr[i] = low.add(step.mult(i));}
    return arr;
}

Complex[] arrayOfZeros(int n){
  Complex[] out = new Complex[n];
  for(int i=0; i<n;i++){
    out[i] = new Complex(0,0);
  }
  return out;
}
Complex[] arrayOfOnes(int n){
  Complex[] out = new Complex[n];
  for(int i=0; i<n;i++){
    out[i] = new Complex(1,0);
  }
  return out;
}

Complex sawtooth(Complex z){
  //returns sawtooth going (0,0)=>(1,0.5)=>(-1.0.5)=>(1,0)...
  return z.sub(z.round()).mult(2d);}

Complex gaussian(Complex z){
  return z.cmag2().neg().exp();
}

Complex gaussianAtGaussianMultiplesOfN(Complex z, Complex n){
    //puts a nice normal bump at all gaussian integer multiples of n, 0ish at other integers
    return gaussian( n.mult(sawtooth(z.divBy(n))) );}


class Complex{
  double re;
  double im;
  
  
  Complex(double r, double i){re = r; im = i;}
  
  String toString(){
    if(re==0){
      if(im < 0){return "(-i" + Double.toString(-im) + ")";}
      return "i" + Double.toString(im);
    } else if (im==0){
      return Double.toString(re);
    } else {
      if (im < 0){
        String RE = Double.toString(re);
        String IM = " - i" + Double.toString(-im);
        return "(" + RE + IM + ")";
      } else {
        String RE = Double.toString(re);
        String IM = " + i" + Double.toString(im);
        return "(" + RE + IM + ")";
      }
    }
  }
  
  //=================ATTRIBUTES and BASIC UNITARY Operators==========================
  
  boolean isNaN(){return Double.isNaN(re) || Double.isNaN(im);}
  
  Complex neg(){return new Complex(-re,-im);}//negative
  Complex conj(){return new Complex(re,-im);}//complex conjugate
  
  double mag2() {return re*re + im*im;}//magnitude squared
  Complex cmag2(){return new Complex(mag2(),0);}
  
  double mag() {return Math.sqrt(re*re + im*im);}//magnitude BEWARE OVERFLOW
  Complex cmag() {return new Complex(mag(),0);}
  double hypot() {return Math.hypot(re,im);}//magnitude without overflow
  Complex chypot() {return new Complex(Math.hypot(re,im),0);}
  
  double arg(){
    if(im == 0){return (re>=0)?0:Math.PI;}
    return Math.atan2(im,re);
  }
  Complex carg(){return new Complex(arg(),0);}
  
  Complex reciprocal(){
    final double len2 = mag2();
    return new Complex(re/len2,-im/len2);
  }
  Complex normalised(){
    final double len = mag(); 
    if(len==0){return new Complex(0,0);}
    return new Complex(re/len,im/len);
  }
  Complex normalisedBIG(){
    final double len = hypot(); 
    if(len==0){return new Complex(0,0);}
    return new Complex(re/len,im/len);
  }
  
  
  //=============ARITHMETIC AND BINARY OPERATORS=====================================
  //comparison
  boolean equals(Complex other) {return re==other.re && im==other.im;}
  boolean equals(Complex other, double within){
     double redif2 =re - other.re;
     double imdif2 =im - other.im;
     redif2 *= redif2;
     imdif2 *= imdif2;
     within *= within;
    return  redif2 < within && imdif2 < within;
  }
  
  //addition
  Complex add(double other){return new Complex(re + other,im);}
  Complex add(Complex other){return new Complex(re + other.re, im + other.im);}
  
  //multiplication
  Complex mult(double other) {return new Complex(re*other,im*other);}
  Complex mult(Complex other){
    final double rOut = re * other.re  -  im*other.im;
    final double iOut = re * other.im  +  im*other.re;  
    return new Complex(rOut,iOut);
  }
  
  //subtraction
  Complex sub(double other){return new Complex(re - other,im);}//subtracts other from this
  Complex sub(Complex other){return new Complex(re-other.re,im - other.im);}
  Complex subFrom(double other){return new Complex(other - re,-im);}//subtracts this from other
  Complex subFrom(Complex other){return new Complex(other.re - re, other.im - im);}
  
  //division
  Complex div(double numerator){return reciprocal().mult(numerator);}//divides numerator by this
  Complex div(Complex numerator){return reciprocal().mult(numerator);}
  Complex divBy(double denominator){return new Complex(re/denominator,im/denominator);}//divides this by denominator
  Complex divBy(Complex denominator){return mult(denominator.reciprocal());}
  
  //======================EXPONENTS AND POWERS=============================
  Complex square(){return new Complex(re*re - im*im, 2*re*im);}
  Complex cube(){return new Complex(re*re*re - 3*re*im*im , 3*re*re*im - im*im*im);}
  
  //natural base e stuff
  Complex exp(){
    if(im==0){return new Complex(Math.exp(re),0);}
    return fromPolar(Math.exp(re),im);
  }
  Complex ln(){return ln(0);}//fast log without intermediate overflow protection
  Complex ln(int branch) {return new Complex(0.5*Math.log(re*re + im*im),arg() + 2*Math.PI*branch);}
  Complex lnBIG(){return lnBIG(0);}//log with intermediate overflow protection
  Complex lnBIG(int branch) {return new Complex(Math.log(Math.hypot(re,im)),arg() + 2*Math.PI*branch);}
  
  //arbitrary base logs
  Complex log(Complex base){return log(base,0);}
  Complex log(Complex base,int branch){return ln(branch).divBy(base.ln(branch));}
  Complex log(double base){return log(new Complex(base,0d),0);}
  Complex log(double base,int branch){return log(new Complex(base,0d),branch);}
  
  //arbitrary base exponents
  Complex raiseTo(double power){return raiseTo(new Complex(power,0d),0);}
  Complex raiseTo(double power,int branch){return raiseTo(new Complex(power,0d),branch);}
  Complex raiseTo(Complex power){return raiseTo(power,0);}
  Complex raiseTo(Complex power,int branch){
    if (re == 0 && im == 0){//when base equals 0
      if (power.re > 0){return new Complex(0,0);}
      else {return new Complex(Double.NaN,Double.NaN);}
    }else if(power.im == 0 && power.re%2==0 && re<0 && im==0){//raising negative number to even power
      return new Complex(Math.pow(-re,power.re),2*branch);
    }
    return ln(branch).mult(power).exp();
  }
  
  Complex raiseBy(double base){return (new Complex(base,0)).raiseTo(this,0);}
  Complex raiseBy(Complex base){return base.raiseTo(this,0);}
  Complex raiseBy(double base,int branch){return (new Complex(base,0)).raiseTo(this,branch);}
  Complex raiseBy(Complex base,int branch){return base.raiseTo(this,branch);}
  
  Complex root(double radicand){return raiseTo(1d/radicand,0);}
  Complex root(double radicand, int branch){return raiseTo(1d/radicand,branch);}
  Complex root(Complex radicand){return raiseTo(radicand.reciprocal(),0);}
  Complex root(Complex radicand,int branch){return raiseTo(radicand.reciprocal(),branch);}
  
  Complex sqrt(){return sqrt(0);}
  Complex sqrt(int branch){return fromPolar(Math.sqrt(mag()),0.5*arg() + Math.PI*branch);}
  Complex sqrtBIG(int branch){return fromPolar(Math.sqrt(hypot()),0.5*arg() + Math.PI*branch);}
  
  
  //=======================TRIGONOMETRIC AND HYPERBOLIC STUFF=================================
  //trig functions
  Complex sin(){
    if (im==0){return new Complex(Math.sin(re),0);}
    final Complex I = new Complex(0,1);
    return mult(I).exp().sub(mult(I.neg()).exp()).divBy(I.mult(2));}
  Complex cos(){
    if (im==0){return new Complex(Math.cos(re),0);}
    final Complex I = new Complex(0,1);
    return mult(I).exp().add(mult(I.neg()).exp()).divBy(2);}
  Complex tan(){
    if (im==0){return new Complex(Math.tan(re),0);}
    return sin().divBy(cos());}
  
  //hyperbolic functions  
  Complex sinh(){
    if (im==0){return new Complex(Math.sinh(re),0);}
    return exp().sub(neg().exp()).divBy(2);}
  Complex cosh(){
    if (im==0){return new Complex(Math.cosh(re),0);}
    return exp().add(neg().exp()).divBy(2);}
  Complex tanh(){
    if (im==0){return new Complex(Math.tanh(re),0);}
    return sinh().divBy(cosh());}
  
  //inverse trig functions
  Complex asin(int branch){
    final Complex I = new Complex(0,1);
    return square().neg().add(1).sqrt(branch).add(mult(I)).ln(branch).mult(I.neg());}
  Complex acos(int branch){return this.asin(branch).neg().add(Math.PI/2);}
  Complex atan(int branch){
    final Complex I = new Complex(0,1);
    return I.divBy(2).mult(add(I).divBy(subFrom(I)).ln(branch));}
  
  //inverse hyperbolic functions
  Complex asinh(int branch){return add(square().add(1).sqrt(branch)).ln(branch);}
  Complex acosh(int branch){return add(this.sub(1).sqrt(branch).mult(add(1).sqrt(branch))).ln(branch);}
  Complex atanh(int branch){return mult(new Complex(0,1)).atan(branch).mult(new Complex(0,-1));}
  
  
  //=======================GAUSSIAN INTEGERS STUFF=================================
  Complex round(){
    //rounds up (towards positive inf) on half integers
    return new Complex(Math.round(re),Math.round(im));
  }
  Complex roundPolar(double snapAngle){
    //rounds up (towards positive inf) on half integers
    double oldArg = arg();
    double newArg = oldArg - (oldArg%snapAngle);
    double newMag = Math.round(mag());
    return fromPolar(newMag,newArg);
  }
  Complex roundPolarHarmonic(double snapAngle){
    //rounds up (towards positive inf) on half integers, for |z|<1 this rounds to the nears 1/n;
    double oldArg = arg();
    double newArg = snapAngle * Math.round(oldArg/snapAngle);
    double oldMag = mag();
    double newMag;
    if(oldMag >= 1){
      newMag = Math.round(oldMag);
    } else {
      newMag = 1d / Math.round(1d/oldMag);
    }
    return fromPolar(newMag,newArg);
  }
  
  Complex[] roundAndError(){
    final double rre = Math.round(re);
    final double rim = Math.round(im);
    Complex[] out = {new Complex(rre,rim),new Complex(re-rre,im-rim)};
    return out;
  }
  Complex floor(){
    return new Complex(Math.floor(re),Math.floor(im));
  }
  
  Complex[] floorAndError(){
    final double rre = Math.floor(re);
    final double rim = Math.floor(im);
    Complex[] out = {new Complex(rre,rim),new Complex(re-rre,im-rim)};
    return out;
  }
  
  Complex modBy(Complex other){
    return divBy(other).floorAndError()[1].mult(other);
  }
  
  Complex[] divmodBy(Complex other){
    Complex trueQuotient = divBy(other);
    Complex[] qNr = trueQuotient.floorAndError();
    qNr[1] = qNr[1].mult(other);
    return qNr;
  }
  //===============PRETENDING THERE'S ORDERING STUFF===========================
  Complex elementAbs(){
    return new Complex(Math.abs(re),Math.abs(im));
  }
}
