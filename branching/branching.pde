ParticleSystem ps;
float a = 7; // .1, 6
float b = 9; // .2, 8
float lambda = .8; // 10, .2
float lambdaKilling = .4;

void setup() {
  size(displayWidth, displayHeight);
  frameRate(80);
  Distribution unif = new UniformDistribution(a, b);
  //ps = new ParticleSystem(lambda, unif, 2);
  Distribution exp = new ExponentialDistribution(lambdaKilling);
  ps = new ParticleSystem(lambda, exp, 1);
  Distribution custom = new CustomDistribution();
  //ps = new ParticleSystem(lambda, custom, 2);
}

void draw () {
  background(0);
  ps.update();
  ps.display();
  if (ps.simulationDone) {
    if (ps.result) print("Survival");
    else print("Extinction at generation " + (ps.generationCount.size() - 1));
    exit();
  }
}