class Particle {
  color[] colors = {#6092F2,#ACC6F8,#D2CEF4};
  float x, y, r;
  color c = #19509B;
  int life; 
  Particle(float _x, float _y, float _r) {
    x= _x;
    y = _y;
    r = _r;
    life = 60;
  }
  void shrink() {
    //r*=1.1;
    //if (life > 30) {r*=1.05;}
    
    r*=0.9;
    if (life > 30) {r*=0.955;}
   // c *= 1.2;
    life--;
  }
  boolean isDead() {
    return life == 0;
  }
}