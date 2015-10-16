ParticleSystem ps;
float a = 5; // .1
float b = 7; // .2
float lambda = .16; // 10

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