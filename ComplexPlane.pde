class ComplexPlane{
  int detail;
  double r;
  ComplexFunction currentFunction;
  Complex[] zplane;
  Complex[] fplane;
  
  ComplexPlane(double _r, int _detail){
    r = _r;
    detail = _detail;
    currentFunction = new CIdentity();
    //cartesianGrid();
    polarGrid();
  }
  
  void cartesianGrid(){
    double dz = 2*r/(detail-1);
    zplane = new Complex[detail*detail];
    fplane = new Complex[detail*detail];
    for(int j=0;j<detail;j++){
      for(int i=0;i<detail;i++){
        zplane[i + detail*j] = new Complex(i*dz - r, j*dz - r);
        fplane[i + detail*j] = new Complex(i*dz - r, j*dz - r);
      }
    }
  }
  void polarGrid(){
    double dAzi = 2d*Math.PI/(detail-2);
    double highestLatitude = Math.atan2(1d - 2d/(r*r + 1d) , 2d*r / (r*r + 1d));
    double dTheta = (Math.PI/2d + highestLatitude) / (detail - 1);
    zplane = new Complex[detail*detail];
    fplane = new Complex[detail*detail];
    for(int j=0;j<detail;j++){
      for(int i=0;i<detail;i++){
        double theta = dTheta*j - Math.PI/2d;
        double azi = i*dAzi;
        double mag = Math.cos(theta) / (1-Math.sin(theta));
        zplane[i + detail*j] = fromPolar(mag,azi);
        fplane[i + detail*j] = fromPolar(mag,azi);
      }
    }
  }
  
  PVector toHeightmap(Complex z,Complex f, float XZscale,float heightScale,int heightSourceMode){
    float h = 0;
    switch (heightSourceMode){
      case 1://abs
        h = (f.isNaN())?(100):(-(float)(f.mag()*heightScale));
        break;
      case 2://re
        h = (f.isNaN())?(100):(-(float)(f.re*heightScale));
        break;
      case 3://im
        h = (f.isNaN())?(100):(-(float)(f.im*heightScale));
        break;
    }
    return new PVector((float)(XZscale*z.re),h,-(float)(XZscale*z.im));
  }
  
  PVector toRiemannSphere(Complex z,float radius){
    PVector out = new PVector();
    double ZMAG2 = z.mag2();
    double ZMAG = Math.sqrt(ZMAG2);
    double ZARG = z.arg();
    //calculate horizontal component
    double r = 2d*ZMAG / (ZMAG2 + 1d);
    out.x =  radius*(float)(r*Math.cos(ZARG));
    out.y = -radius*(float)(1d - 2d/(ZMAG2 + 1));
    out.z = -radius*(float)(r*Math.sin(ZARG));
    return out;
  }
  
  Complex getZ(int i, int j){return zplane[i + detail*j];}
  Complex getF(int i, int j){return fplane[i + detail*j];}
  
  void applyFunction(ComplexFunction func){
    currentFunction = func;
    for(int j=0;j<detail;j++){
      for(int i=0;i<detail;i++){
        fplane[i + detail*j] = func.f(zplane[i + detail*j]);
      }
    }
  }

  void show(float radius,float heightScale,float spheriness,ComplexColorMap cmap,int heightMode){
    noStroke();
    //strokeWeight(1);
    //stroke(100);
    for(int j=0;j<detail - 1;j++){
      beginShape(TRIANGLE_STRIP);
      for(int i=0;i<detail - 1;i++){
        //the S stands for "south" because these points are 1 down
        Complex  z  = getZ(i,j);
        Complex zS  = getZ(i,j+1);
        Complex  f  = getF(i,j);
        Complex fS  = getF(i,j+1);
        //the ps stands for Point-on-Sphere
        //the pp stands for Point-on-Plane
        PVector ps,psS,pp,ppS,p,pS;
        if(spheriness == 0){
          pp = toHeightmap(z,f,radius,heightScale,heightMode);
          ppS = toHeightmap(zS,fS,radius,heightScale,heightMode);
          p = pp;
          pS = ppS;
        } else if (spheriness == 1){
          ps = toRiemannSphere(z,radius);
          psS = toRiemannSphere(zS,radius);
          p = ps;
          pS = psS;
        } else {
          pp = toHeightmap(z,f,radius,heightScale,heightMode);
          ppS = toHeightmap(zS,fS,radius,heightScale,heightMode);
          ps = toRiemannSphere(z,radius);
          psS = toRiemannSphere(zS,radius);
          p = pp.lerp(ps,spheriness);
          pS = ppS.lerp(psS,spheriness);
        }
        fill(cmap.map(f));
        vertex(p.x,p.y,p.z);
        fill(cmap.map(fS));
        vertex(pS.x,pS.y,pS.z);
      }
      endShape();
    }
  }
  
}
