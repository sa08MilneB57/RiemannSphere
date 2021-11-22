class CPolynomial implements ComplexFunction{
  Complex[] coefficients;
  CPolynomial(Complex[] c){ coefficients = c; }
  CPolynomial(){coefficients = new Complex[0];}//empty polynomial for extended classes
  @Override
  String toString(){return name();}
  
  String name(){
    final Complex ZERO = new Complex(0,0);
    final Complex ONE = new Complex(1,0);
    String out = "";
    for(int i=0;i<coefficients.length;i++){
      if(coefficients[i].equals(ZERO)){
         continue;
      } else if (i==0){
        out += coefficients[i].toString() + " + ";
      } else if (coefficients[i].equals(ONE)){
        out += "z^" + i + " + ";
      } else if (i==0){
        out += coefficients[i].toString() + " + ";
      } else {
        out += coefficients[i].toString() + "z^" + i + " + ";
      }
    }
    out = out.substring(0,out.length() - 3);
    return out;
  }
  
  Complex f(Complex x){
    Complex out = coefficients[0];
    Complex currentPower = new Complex(1,0);
    final Complex ZERO = new Complex(0,0);
    for(int i=1;i<coefficients.length;i++){
      currentPower = currentPower.mult(x);
      if(!coefficients[i].equals(ZERO)){
        out = out.add( coefficients[i].mult(currentPower) );
      }
    }
    return out;
  }
  
  CPolynomial add(CPolynomial other){
    int longLength = Math.max(coefficients.length,other.coefficients.length);
    int shortLength = Math.min(coefficients.length,other.coefficients.length);

    Complex[] newCoefs = new Complex[longLength];
    Complex[] shortCoefs, longCoefs;
    if(coefficients.length > other.coefficients.length){
      longCoefs = coefficients;
      shortCoefs = other.coefficients;
    } else {
      shortCoefs = coefficients;
      longCoefs = other.coefficients;
    }
    
    for(int i=0; i<newCoefs.length;i++){
      if (i>=shortLength){
        newCoefs[i] = longCoefs[i];
      } else {
        newCoefs[i] = shortCoefs[i].add(longCoefs[i]);
      }
    }
    return new CPolynomial(newCoefs);
  }
  
  CPolynomial mult(CPolynomial other){
    final Complex ZERO = new Complex(0,0);
    int thislength = coefficients.length;
    int othrlength = other.coefficients.length;
    Complex[] newCoefs = new Complex[thislength + othrlength - 1];
    for(int i=0; i<thislength; i++){
      for(int j=0; j<thislength; j++){
        if(newCoefs[i+j] == null){newCoefs[i+j] = ZERO;}
        Complex product = coefficients[i].mult(other.coefficients[j]);
        newCoefs[i+j] = newCoefs[i+j].add(product);
      }  
    }
    return new CPolynomial(newCoefs);
  }
  
  CPolynomial derivative(){
    if(coefficients.length <= 1){
      Complex [] coefs = {new Complex(0,0)};
      return new CPolynomial(coefs);
    }
    Complex[] newcoefs = new Complex[coefficients.length - 1];
    for(int i=0; i<newcoefs.length;i++){
      newcoefs[i] = coefficients[i+1].mult(i+1);
    }
    return new CPolynomial(newcoefs);
  }
  
  CPolynomial antiderivative(){return antiderivative(new Complex(0,0));}
  CPolynomial antiderivative(Complex c){
    Complex[] newcoefs = new Complex[coefficients.length + 1];
    newcoefs[0] = c;
    for(int i=0; i < coefficients.length;i++){
      newcoefs[i+1] = coefficients[i].divBy(i + 1);
    }
    return new CPolynomial(newcoefs);
  }
  
  CPolynomial dx(int n){
    if (n==0){
            return new CPolynomial(coefficients);
    } else if (n==1){
        return derivative();
    } else if (n>0){
        return dx(n-1).derivative();
    } else if (n==-1){
        return antiderivative();
    } else if (n<0){
        return dx(n+1).antiderivative();
    }
    throw new RuntimeException("Should be unreachable. Polynomial derivative dx");
  }
  
}

CPolynomial fromRoots(Complex[] roots){
  final Complex ONE = new Complex(1,0);
  Complex[] start = {ONE};
  CPolynomial out = new CPolynomial(start);
  for(Complex root: roots){
    Complex[] monoterms = {root.neg(),ONE};
    CPolynomial monomial = new CPolynomial(monoterms);
    out.mult(monomial);
  }
  return out;
}

class CHermitePolynomial extends CPolynomial{
  int order;
  CHermitePolynomial(int n){
    super();
    order = n;
    coefficients = arrayOfZeros(n + 1);
    for(int m=0; m <= n/2; m++){
      int power = n - 2*m;
      int sign = (m%2 == 0)?1:-1; // (-1)^m
      double twoPart = (1L << power); //2^(n-2m)
      double factTop = fallingFactorial(n,n-m); //n!/m!
      double factBottom = factorial(power); // (n-2m)!
      double wholeTerm = sign * (factTop / factBottom) * twoPart;
      coefficients[power] = new Complex(wholeTerm,0);
    }
  }
  @Override
  String name(){return "H" + order + "(z)";}
}
