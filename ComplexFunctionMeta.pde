class ProductWrapper implements ComplexFunction{
  ComplexFunction[] functions;
  ProductWrapper(ComplexFunction f1,ComplexFunction f2){
    functions = new ComplexFunction[2];
    functions[0] = f1;
    functions[1] = f2;
  }
  ProductWrapper(ComplexFunction[] funcs){functions = funcs;}
  String name(){
    String out = "";
    for(ComplexFunction func : functions){
      out += ("(" + func.name() + ")") + " * ";
    }
    return out.substring(0,out.length() - 3);
  }
  String menuName(){return name();}
  
  Complex f(Complex z){
    Complex out = new Complex(1,0);
    for(ComplexFunction func : functions){
      out = out.mult(func.f(z));
    }
    return out;
  }
}
class QuotientWrapper implements ComplexFunction{
  ComplexFunction N,D;
  QuotientWrapper(ComplexFunction num,ComplexFunction den){
    N = num;
    D = den;
  }
  String name(){
    return "(" + N.name() + ") / (" + D.name() + ")";
  }
  String menuName(){return name();}
  
  Complex f(Complex z){
    return N.f(z).divBy(D.f(z));
  }
}


class ComposeWrapper implements ComplexFunction{
  ComplexFunction outer,inner;
  ComposeWrapper(ComplexFunction outerfunction, ComplexFunction innerfunction){
    outer = outerfunction;
    inner = innerfunction;
  }
  String name(){return outer.name().replaceAll("z",inner.name());}
  String menuName(){return name();}
  Complex f(Complex z){return outer.f(inner.f(z));}
  
}
