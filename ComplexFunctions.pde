interface ComplexFunction {
  String name();
  String menuName();
  Complex f(Complex z);
}
class CIdentity implements ComplexFunction{
  String name(){return "z";}
  String menuName(){return name();}
  Complex f(Complex z){return z;}
}
class CConstant implements ComplexFunction{
  Complex constant;
  CConstant(Complex c){constant = c;}  
  String name(){return constant.toString();}
  String menuName(){return name();}
  Complex f(Complex z){return constant;}
}
class CScale implements ComplexFunction{
  Complex constant;
  CScale(Complex c){constant = c;}  
  String name(){return constant.toString() + " * z";}
  String menuName(){return name();}
  Complex f(Complex z){return z.mult(constant);}
}

class CReciprocal implements ComplexFunction{
  String name(){return "1/z";}
  String menuName(){return name();}
  Complex f(Complex z){return z.reciprocal();}
}
class CSqrt implements ComplexFunction{
  String name(){return "sqrt(z)";}
  String menuName(){return name();}
  Complex f(Complex z){return z.sqrt();}
}


class CSin implements ComplexFunction{
  String name(){return "sin(z)";}
  String menuName(){return name();}
  Complex f(Complex z){return z.sin();}
}
class CCos implements ComplexFunction{
  String name(){return "cos(z)";}
  String menuName(){return name();}
  Complex f(Complex z){return z.cos();}
}
class CTan implements ComplexFunction{
  String name(){return "tan(z)";}
  String menuName(){return name();}
  Complex f(Complex z){return z.tan();}
}
class CASin implements ComplexFunction{
  String name(){return "asin(z)";}
  String menuName(){return name();}
  Complex f(Complex z){return z.asin(0);}
}
class CACos implements ComplexFunction{
  String name(){return "acos(z)";}
  String menuName(){return name();}
  Complex f(Complex z){return z.acos(0);}
}
class CATan implements ComplexFunction{
  String name(){return "atan(z)";}
  String menuName(){return name();}
  Complex f(Complex z){return z.atan(0);}
}


class CSinh implements ComplexFunction{
  String name(){return "sinh(z)";}
  String menuName(){return name();}
  Complex f(Complex z){return z.sinh();}
}
class CCosh implements ComplexFunction{
  String name(){return "cosh(z)";}
  String menuName(){return name();}
  Complex f(Complex z){return z.cosh();}
}
class CTanh implements ComplexFunction{
  String name(){return "tanh(z)";}
  String menuName(){return name();}
  Complex f(Complex z){return z.tanh();}
}
class CASinh implements ComplexFunction{
  String name(){return "asinh(z)";}
  String menuName(){return name();}
  Complex f(Complex z){return z.asinh(0);}
}
class CACosh implements ComplexFunction{
  String name(){return "acosh(z)";}
  String menuName(){return name();}
  Complex f(Complex z){return z.acosh(0);}
}
class CATanh implements ComplexFunction{
  String name(){return "atanh(z)";}
  String menuName(){return name();}
  Complex f(Complex z){return z.atanh(0);}
}

class CQuartish implements ComplexFunction{
  Complex ONE = new Complex(1,0);
  Complex ZERO = new Complex(0,0);
  Complex[] coefsN = {ONE,ZERO,ONE};
  Complex[] coefsD = {ONE.neg(),ZERO,ONE};
  ComplexFunction ratio = new QuotientWrapper(new CPolynomial(coefsN),new CPolynomial(coefsD));
  String name(){return ratio.name();}
  String menuName(){return name();}
  Complex f(Complex z){return ratio.f(z);}
}

class CSquare implements ComplexFunction{
  String name(){return "z^2";}
  String menuName(){return name();}
  Complex f(Complex z){return z.square();}
}
class CCube implements ComplexFunction{
  String name(){return "z^3";}
  String menuName(){return name();}
  Complex f(Complex z){return z.cube();}
}

class CPow implements ComplexFunction{
  int power;
  CPow(int pow){power = pow;}
  String name(){return "z^" + power;}
  String menuName(){return name();}
  Complex f(Complex z){return z.raiseTo(power);}
}

class CExp implements ComplexFunction{
  String name(){return "exp(z)";}
  String menuName(){return name();}
  Complex f(Complex z){return z.exp();}
}
class CLog implements ComplexFunction{
  String name(){return "ln(z)";}
  String menuName(){return name();}
  Complex f(Complex z){return z.ln();}
}
class CGauss implements ComplexFunction{
  String name(){return "exp(-z^2)";}
  String menuName(){return name();}
  Complex f(Complex z){return z.square().neg().exp();}
}
class CGaussAbs implements ComplexFunction{
  String name(){return "exp(-|z|^2)";}
  String menuName(){return name();}
  Complex f(Complex z){return z.cmag2().neg().exp();}
}

class CBinet implements ComplexFunction{
  final Complex Phi = new Complex(1.618033988749894d,0); //principal golden ratio
  final Complex phi = new Complex(-0.618033988749894d,0);//"sister" golden ratio
  final double inroot5 = 0.447213595499957d;//1/sqrt(5);
  String name(){return "Binet(z) (Fibonacci numbers)";}
  String menuName(){return name();}
  Complex f(Complex z){return Phi.raiseTo(z).sub(phi.raiseTo(z)).mult(inroot5);}
}

class CErf implements ComplexFunction{
  double oneOverDz;
  final double twoOnRootPi = 1.1283791670955125738961589031215451716881012586579977136881714434d;
  CErf(double dz){oneOverDz=1d/dz;}
  
  String name(){return "erf(z)";}
  String menuName(){return name();}
  Complex f(Complex z){
    int detail = (int)Math.round(z.mag() * oneOverDz);
    ComplexFunction gaussian = new CGauss();
    IntegralLine line = new ComplexBounds(new Complex(0,0),z);
    Integral integral = new Integral(gaussian,line);
    return integral.evaluateSimpson(detail).mult(twoOnRootPi);
  }
}

class CGamma implements ComplexFunction{
  int detail;
  CGamma(int _detail){detail=_detail;}
  String name() {return "Gamma(z)";}
  String menuName(){return name();}
  Complex f(Complex z){      
    ComplexFunction reciprocal = new CReciprocalGamma(detail);
    return reciprocal.f(z).reciprocal();
  }
}


class CReciprocalGamma implements ComplexFunction{
  final double gamma = 0.57721566490153286060d;//euler-mascheroni constant
  int terms;
  CReciprocalGamma(int accuracy){terms = accuracy;}
  String name(){return "1/Gamma(z)";}
  String menuName(){return name();}
  Complex f(Complex z){
    Complex out = z.mult(z.mult(gamma).exp());
    for (int n=1; n<terms;n++){
      Complex zOnN = z.divBy(n);
      out = out.mult( zOnN.add(1).mult(zOnN.neg().exp()) );
    }
    return out;
  }
}



class CZeta implements ComplexFunction{
  //Using Helmut Hasse's globally convergent series
  int detail;
  final Complex ZERO = new Complex(0,0);
  final Complex TWO = new Complex(2,0);
  CZeta(int _detail){detail=_detail;}
  String name() {return "Zeta(z)";}
  String menuName(){return name();}
  Complex f(Complex s){  
    Complex leading = TWO.raiseTo(s.subFrom(1)).subFrom(1).reciprocal();
    Complex out = ZERO;
    for (int n=0; n<detail; n++){
      Complex binPart = ZERO;
      for (int k=0; k<=n; k++){
        double bin = ((k%2 == 0)?1:-1) * binomial(n,k);
        Complex summand = new Complex(k+1,0).raiseTo(s).reciprocal().mult(bin);
        binPart = binPart.add(summand);
      }
      binPart.re = Math.scalb(binPart.re,-n-1);
      binPart.im = Math.scalb(binPart.im,-n-1);
      out = out.add(binPart);
    }
    return out.mult(leading);
  }
  
  double binomial(int n, int k){
    double out = 1;
    double N = n;
    for(int i=1; i<=k; i++){
      out *= (N + 1d - i) / i;
    }
    return out;
  }
}

class CMandel implements ComplexFunction{
  int iters;
  String name;
  CMandel(int _iters){
    iters = _iters;
    name = "M" + Integer.toString(iters) + "(z)";
    name = name.replaceAll("0", "⁰");    name = name.replaceAll("1", "¹");
    name = name.replaceAll("2", "²");    name = name.replaceAll("3", "³");
    name = name.replaceAll("4", "⁴");    name = name.replaceAll("5", "⁵");
    name = name.replaceAll("6", "⁶");    name = name.replaceAll("7", "⁷");
    name = name.replaceAll("8", "⁸");    name = name.replaceAll("9", "⁹");  
  }
  String name(){return name;}
  String menuName(){return name();}
  Complex f(Complex z){
    Complex c = z.mult(1);//creates a copy
    for (int i=0; i<iters; i++){
      z = z.square().add(c);
    }
    return z;
  }
}
