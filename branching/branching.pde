ParticleSystem ps;
float a = 7; // .1, 6
float b = 9; // .2, 8
//float lambda = .8;
float lambda = .6; // 10, .2
float lambdaKilling = .4;

/*
 * Development notes:
 * Processing JS incompatibilities
 * Cannot use external libraries, including java.util
 * Cannot use displayWidth or displayHeight variables
 * Cannot use the tag @Override
 * Cannot use Float wrapper
 * Must typecast redundantly to avoid errors
 * Must be careful using names of functions:
 * Cannot make another size() function for a class
 */

// Interesting parameters:
// custom distribution, lambda .8, killing .4
// custom, lambda = .6, killing = .4 (after revision to birthtime determination)
// Conditional (mode 3): lambda .8, constant 6
// Conditional B-A (mode 4): lambda .6, constant 6 (max capacity may not be accurate)

double simWidth = 400;
double simHeight = 400;
boolean simRunning = false;
void setup() {
  size(400, 400);
  frameRate(80);
  Distribution unif = new UniformDistribution(a, b);
  //ps = new ParticleSystem(lambda, unif, 2, 0);
  Distribution exp = new ExponentialDistribution(lambdaKilling);
  //ps = new ParticleSystem(lambda, exp, 3, 6);
  //ps = new ParticleSystem(lambda, exp, 4, 6, simWidth, simHeight);
  Distribution custom = new CustomDistribution();
  //ps = new ParticleSystem(lambda, custom, 2, 0);
  noLoop();
  //startSketch();
}

void startSketch() {
  if (!simRunning) {
    simRunning = true;
    Distribution exp = new ExponentialDistribution(lambdaKilling);
    ps = new ParticleSystem(lambda, exp, 4, 6, simWidth, simHeight);
    loop();
  }
}

void draw () {
  background(0);
  ps.update();
  ps.display();
  if (ps.simulationDone) {
    if (ps.result) println("Survival");
    else println("Extinction at generation " + (ps.generationCount.size() - 1));
    //exit();
    noLoop();
  }
}