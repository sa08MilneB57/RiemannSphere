
abstract class RealColorMap {
  abstract color map(double t);
}

abstract class ComplexColorMap {
  abstract color map(Complex z);
}

class ReImtoRB extends ComplexColorMap {
  double scalefactor;
  ReImtoRB(double threshold) {
    scalefactor=1/threshold;
  }

  color map(Complex z) {
    if (z.isNaN()) {
      return color(127);
    }
    float r = (float)( 255 * Math.max( 1 - Math.abs(z.re)*scalefactor , 0 ) );
    float b = (float)( 255 * Math.max( 1 - Math.abs(z.im)*scalefactor , 0 ) );
    return color(r, 0, b);
  }
}

class ArgandToHueBright extends ComplexColorMap {
  double maxExpected;
  ArgandToHueBright(double _maxExpected) {
    maxExpected=_maxExpected;
  }
  color map(Complex z) {
    if (z.isNaN()) {
      return color(127);
    }
    final float hue = (float)(z.arg()%TAU + TAU) % TAU;
    final double mag = z.mag();
    float l;
    if (mag <= maxExpected) {
      l = (float)(0.5d*mag/maxExpected);
    } else {
      l = (float)(0.5d*(2d - (maxExpected/(Math.log(mag - maxExpected + 1) + maxExpected))));
    }
    return HSL(hue, 1, l);
  }
}
class ArgandGrid extends ComplexColorMap {
  double maxExpected,gridsize;
  ArgandGrid(double _maxExpected,double _gridsize) {
    maxExpected=_maxExpected;
    gridsize = _gridsize;
  }
  color map(Complex z) {
    if (z.isNaN()) {
      return color(127);
    }
    final float hue = (float)(z.arg()%TAU + TAU) % TAU;
    final double mag = z.mag();
    double gridnessX = Math.abs(z.re/gridsize - Math.round(z.re/gridsize));
    double gridnessY = Math.abs(z.im/gridsize - Math.round(z.im/gridsize));
    double gridness = Math.sqrt(Math.min(gridnessX , gridnessY))  + 0.2;
    float l;
    if (mag <= maxExpected) {
      l = (float)(0.5d*mag/maxExpected);
    } else {
      l = (float)(0.5d*(2d - (maxExpected/(Math.log(mag - maxExpected + 1) + maxExpected))));
    }
    l *= gridness;
    return HSL(hue, 1, l);
  }
}

class ArgandPolar extends ComplexColorMap {
  double maxExpected,radialGrid,dTheta;
  ArgandPolar(double _maxExpected,double _radialGrid, int angles) {
    maxExpected=_maxExpected;
    radialGrid = _radialGrid;
    dTheta = TAU / angles;
  }
  color map(Complex z) {
    if (z.isNaN()) {
      return color(127);
    }
    final float hue = (float)(z.arg()%TAU + TAU) % TAU;
    final double mag = z.mag();
    final double arg = z.arg();
    double gridnessM = Math.abs(mag/radialGrid - Math.round(mag/radialGrid));
    double gridnessA = Math.abs(arg/dTheta - Math.round(arg/dTheta));
    double gridness = Math.sqrt(Math.min(gridnessM , gridnessA)) + 0.2;
    float l;
    if (mag <= maxExpected) {
      l = (float)(0.5d*mag/maxExpected);
    } else {
      l = (float)(0.5d*(2d - (maxExpected/(Math.log(mag - maxExpected + 1) + maxExpected))));
    }
    l *= gridness;
    return HSL(hue, 1, l);
  }
}

class ArgandStripedRB extends ComplexColorMap {
  double gridFactor,dTheta;
  ArgandStripedRB(double gridsize) {
    gridFactor = 1d/gridsize;
  }
  color map(Complex z) {
    if (z.isNaN()) {
      return color(127);
    }
    final double re = gridFactor*z.re;
    final double im = gridFactor*z.im;
    float red = (float)(((re % 1d) + 1d) % 1d);
    red = 200*red + 35;
    float blue = (float)(((im % 1d) + 1d) % 1d);
    blue = 200*blue + 35;
    
    return color(red, 0, blue);
  }
}
class ArgandStripedLogRB extends ComplexColorMap {
  double logFactor,dTheta;
  ArgandStripedLogRB(double logBase) {
    logFactor = 1d/Math.log(logBase);
  }
  color map(Complex z) {
    if (z.isNaN()) {
      return color(127);
    }
    final double re = logFactor*Math.log(Math.abs(z.re));
    final double im = logFactor*Math.log(Math.abs(z.im));
    float red = (float)(((re % 1d) + 1d) % 1d);
    red = 200*red + 35;
    float blue = (float)(((im % 1d) + 1d) % 1d);
    blue = 200*blue + 35;
    
    return color(red, (red+blue)/2, blue);
  }
}

class ArgandStripedPolar extends ComplexColorMap {
  double gridFactor,dTheta;
  ArgandStripedPolar(double radialGrid, int angles) {
    gridFactor = 1d/radialGrid;
    dTheta = TAU / angles;
  }
  color map(Complex z) {
    if (z.isNaN()) {
      return color(127);
    }
    final float hue = (float)(z.arg()%TAU + TAU) % TAU;
    final double mag = gridFactor*z.mag();
    float l = (float)(((mag % 1d) + 1d) % 1d);
    l = 0.7*l + 0.1;
    
    return HSL(hue, 1, l);
  }
}
class ArgandStripedLogPolar extends ComplexColorMap {
  double logFactor,dTheta;
  ArgandStripedLogPolar(double logBase, int angles) {
    logFactor= 1d / Math.log(logBase);
    dTheta = TAU / angles;
  }
  color map(Complex z) {
    if (z.isNaN()) {
      return color(127);
    }
    final float hue = (float)(z.arg()%TAU + TAU) % TAU;
    final double logMag = 0.5*logFactor*Math.log(z.mag2());
    float l = (float)(((logMag % 1d) + 1d) % 1d);
    l = 0.7*l + 0.1;
    
    return HSL(hue, 1, l);
  }
}


class ArgandToYCoCg extends ComplexColorMap {
  double maxExpected;
  float chromaNormalisationFactor;
  ArgandToYCoCg(double _maxExpected) {
    maxExpected=_maxExpected;
    chromaNormalisationFactor = 0.5f / chromaFunction((float)maxExpected);
  }
  float chromaFunction(float x){
    float c = sqrt((float)(maxExpected*maxExpected) - 1);
    //float c = (float)maxExpected;
    float xSubc = x-c;
    return x / (1 + xSubc*xSubc);
  }
  color map(Complex z) {
    if (z.isNaN()) {
      return color(127);
    }
    final float theta = (float)(z.arg()%TAU + TAU) % TAU;
    final double mag = z.mag();
    float Y;
    float chroma = chromaFunction((float)mag)*chromaNormalisationFactor;
    if (mag <= maxExpected) {
      Y = max(0 ,min((float)(0.5d*mag/maxExpected),1));
      
    } else {
      Y = (float)(0.5d*(2d - (maxExpected/(Math.log(mag - maxExpected + 1) + maxExpected))));
      
    }
    return YCoCg(Y,chroma*sin(theta),chroma*cos(theta));
  }
}
