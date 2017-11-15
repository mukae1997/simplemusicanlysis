class ParticleSystem {
  color[] colors = {#6092F2,#ACC6F8,#D2CEF4};
  ArrayList<Particle> ripples = new ArrayList<Particle>();
  int systemSize = 3;
  float bandY;
  float half = 100.0;
  int locx = 0;
  ParticleSystem(float b) {
    bandY = b;
    //for (int i = 0; i < systemSize; i++) {
    //  float x = random(0.2, 0.8)*width;
    //  float y = bandY;
    //  ripples.add(new Particle(x, y, half));
    //}
  }
  void update() {
    // clear dead Particles
    for (int i = 0; i < ripples.size(); i++) {
      if (ripples.get(i).isDead()) {
        ripples.remove(i);
      } else {
        ripples.get(i).shrink();  // every 1/60 s
      }
    }
    // update radius
  }
  void add() {
    //float x = random(0.5, 0.8)*width;
    locx += 80;
    float x = width/2 + (locx)%300;
    float y = bandY;
    ripples.add(new Particle(x, y, half));
  }
  void show() {
    for (int i = 0; i < ripples.size(); i++) {
      noStroke();
      //fill((map(bandY, 0, height, 0, 30) )*bandY,   bandY/2,    230);
        noFill();
        stroke(ripples.get(i).c);
        strokeWeight(1);
      ellipse(ripples.get(i).x, ripples.get(i).y, ripples.get(i).r, ripples.get(i).r);
    }
  }
}