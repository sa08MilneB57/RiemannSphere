color YCoCg(float Y, float Co, float Cg){return YCoCg(Y,Co,Cg,1f);}
color YCoCg(float Y, float Co, float Cg,float alpha){
  //Y:[0,1] ;  Co,Cg:[-0.5,0.5]
  float tmp =     Y   -  Cg;
  float R = 255f*(tmp +  Co);
  float G = 255f*(Y   +  Cg);
  float B = 255f*(tmp -  Co);
  return color(R,G,B,255f*alpha);  
}

float[] inverseYCoCg(color col){return inverseYCoCg(red(col),green(col),blue(col));}
float[] inverseYCoCg(float R,float G, float B){
  R /= 2f*255f;
  G /= 2f*255f;
  B /= 2f*255f;
  
  float[] ycocg = {0.5*(R+B) + G,
                   (R-B),
                   G - 0.5*(R+B)};
  return ycocg;
}

float[] inverseHSL(color col){return inverseHSL(red(col),green(col),blue(col));}
float[] inverseHSL(float R,float G, float B){
  R /= 255f;
  G /= 255f;
  B /= 255f;
  final float Cmax = max(R,G,B);
  final float Cmin = min(R,G,B);
  final float delta = Cmax - Cmin;
  final float L = 0.5*(Cmax + Cmin);
  float H,S;
  if (delta==0){
    H = 0f;
    S = 0f;
  } else {
    S = delta/(1f-abs(2*L-1f));
    final float sect = PI/3;
    if (Cmax == R){
      H = sect*( ( (G-B)/delta ) % 6 );
    } else if (Cmax == G){
      H = sect*( ( (B-R)/delta ) + 2 );
    } else if (Cmax == B){
      H = sect*( ( (R-G)/delta ) + 4 );      
    } else {
      throw new RuntimeException("Impossible colour, unreachable code with RGB: (" + R + "," + G + "," + B + ")");
    }
  }
  
  float[] hsl = {H,S,L};
  return hsl;
}


color HSL(float H, float S, float L) {return HSL(H,S,L,1);}
color HSL(float H, float S, float L,float alpha) {
  //L and S in [0,1], H in [0,2pi]
  H = ((H%TAU)+TAU)%TAU;
  float C = (1 - abs(2*L - 1)) * S;
  float Hp = 3*H / PI;
  float X = C*(1 - abs((Hp % 2) - 1));
  float R, G, B;
  if (S == 0 || L==0 || L==1) {
    R=0;
    G=0;
    B=0;
  } else {
    switch(floor(Hp)) {
    case 0:
      R=C; 
      G=X; 
      B=0;
      break;
    case 1:
      R=X; 
      G=C; 
      B=0;
      break;
    case 2:
      R=0; 
      G=C; 
      B=X;
      break;
    case 3:
      R=0; 
      G=X; 
      B=C;
      break;
    case 4:
      R=X; 
      G=0; 
      B=C;
      break;
    case 5:
      R=C; 
      G=0; 
      B=X;
      break;
    default:
      R=0; 
      G=0; 
      B=0;
    }
  }
  float m = L - 0.5*C;
  return color(255*(R+m), 255*(G+m), 255*(B+m),255*alpha);
}
