ParticleSystem ps;
float a = 7; // .1, 6
float b = 9; // .2, 8
float lambda = .6; // 10, .2
float lambdaKilling = .4;

// Interesting parameters:
// custom distribution, lambda .8, killing .4
// custom, lambda = .6, killing = .4 (after revision to birthtime determination)
// Conditional (mode 3): lambda .8, constant 6
// Conditional B-A (mode 4): lambda .6, constant 6 (max capacity may not be accurate)

void setup() {
  size(displayWidth, displayHeight);
  frameRate(80);
  Distribution unif = new UniformDistribution(a, b);
  //ps = new ParticleSystem(lambda, unif, 2, 0);
  Distribution exp = new ExponentialDistribution(lambdaKilling);
  ps = new ParticleSystem(lambda, exp, 4, 6);
  Distribution custom = new CustomDistribution();
  //ps = new ParticleSystem(lambda, custom, 2, 0);
}

void draw () {
  background(0);
  ps.update();
  ps.display();
  if (ps.simulationDone) {
    if (ps.result) println("Survival");
    else println("Extinction at generation " + (ps.generationCount.size() - 1));
    exit();
  }
}