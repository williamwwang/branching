ParticleSystem ps;
float a = 6; // .1
float b = 8; // .2
float lambda = .2; // 10

void setup() {
  size(displayWidth, displayHeight);
  frameRate(80);
  Distribution unif = new UniformDistribution(a, b);
  ps = new ParticleSystem(lambda, unif);
} 

void draw () {
  background(0);
  ps.update();
  ps.display();
}