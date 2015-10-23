ParticleSystem ps;
float a = 7; // .1, 6
float b = 9; // .2, 8
float lambda = .2; // 10, .2

void setup() {
  size(displayWidth, displayHeight);
  frameRate(80);
  Distribution unif = new UniformDistribution(a, b);
  ps = new ParticleSystem(lambda, unif, 2);
} 

void draw () {
  background(0);
  ps.update();
  ps.display();
}