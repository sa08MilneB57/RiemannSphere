long fallingFactorial(int x, int p){
  long out = 1;
  for (int k=0;k<p;k++){
    out *= x-k;
  }
  return out;
}

long factorial(int x){
  long out = 1;
  for (int k=1;k<=x;k++){
    out *= k;
  }
  return out;
}
