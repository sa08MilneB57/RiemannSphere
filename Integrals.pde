public class NotImplementedException extends RuntimeException{
  public NotImplementedException() {super("This feature is not yet implemented.");}
}

interface IntegralLine{
  boolean improper();
  Complex value(double t);
}

class RealBounds implements IntegralLine{
  double start, end;
  RealBounds(double _start,double _end){
    start = _start;
    end = _end;
  }
  boolean improper(){return false;}
  Complex value(double t){
    return new Complex(start + (end - start)*t,0d);
  }
}
class ComplexBounds implements IntegralLine{
  Complex start, end;
  ComplexBounds(Complex _start,Complex _end){
    start = _start;
    end = _end;
  }
  boolean improper(){return false;}
  Complex value(double t){
    return start.add( end.sub(start).mult(t) );
  }
}

class CircleContour implements IntegralLine{
  double radius, turns, offsetAngle;
  CircleContour(double r){radius =r; turns=1; offsetAngle = 0d;}
  CircleContour(double r,double trns,double offset){
    radius =r;
    turns=trns;
    offsetAngle = offset;}
  boolean improper(){return false;}
  Complex value(double t){
    return fromPolar(radius,turns*2*Math.PI*t + offsetAngle);
  }
}

class Integral{
  IntegralLine contour;
  ComplexFunction f;
  Integral(ComplexFunction _f,double start, double end){
    f = _f;
    contour = new RealBounds(start,end);
  }
  Integral(ComplexFunction _f,IntegralLine _contour){
    f = _f;
    contour = _contour;
  }
  
  
  Complex evaluateTrapezoid(int detail){
    if(contour.improper()){throw new NotImplementedException();}
    double lerpStep = 1d/detail;//contour accepts inputs 0 to 1
    Complex total = new Complex(0,0); //running total
    Complex oldT = contour.value(0);
    Complex oldZ = f.f(oldT);
    for(int i=1; i <= detail ;i++){
      //ends at t=1, adds trapezoid from last point to this point
      Complex t = contour.value(i*lerpStep);
      Complex z = f.f(t);
      Complex dt = t.sub(oldT);
      
      total = total.add( z.add(oldZ).mult(0.5d).mult(dt) );
      
      oldT = t;
      oldZ = z;
    }
    return total;    
  }
  
  
  Complex evaluateSimpson(int detail){
    if(contour.improper()){throw new NotImplementedException();}
    double lerpStep = 1d/detail;//contour accepts inputs 0 to 1
    Complex total = new Complex(0,0); //running total
    Complex oldT = contour.value(0);
    Complex oldZ = f.f(oldT);
    for(int i=1; i <= detail ;i++){
      //ends at t=1, adds trapezoid from last point to this point
      Complex t = contour.value(i*lerpStep);
      Complex midT = t.add(oldT).mult(0.5d);
      Complex z = f.f(t);
      Complex midZTerm = f.f(midT).mult(4d);
      Complex dtFactor = t.sub(oldT).mult(1d/6d);
      
      total = total.add( dtFactor.mult( oldZ.add(midZTerm).add(z) ) );
      
      oldT = t;
      oldZ = z;
    }
    return total;    
  }
}
