ParticleSystem ps;

void setup() {
  size(displayWidth, displayHeight);
  frameRate(80);
  Distribution unif = new UniformDistribution(4, 5);
  ps = new ParticleSystem(.3, unif);
} 

void draw () {
  background(0);
  ps.update();
  ps.display();
}