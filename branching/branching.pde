import java.util.PriorityQueue;
import java.util.Comparator;
import java.util.ArrayList;

double timeScale = (double) 1 / 1000;
//Distribution sUnif = new UniformDistribution(0, 1);
//Function sUnifCDF = sUnif.cdf;
float lambda = (float) 1/100;
RNG rexp = new RNG(new ExponentialDistribution(lambda));
ArrayList<Float> sample1 = rexp.sample(5000);
ArrayList<Float> sample2 = rexp.sample(5000);
RNG runif = new RNG(new UniformDistribution(0, 400));
ArrayList<Float> unifSample1 = runif.sample(5000);
ArrayList<Float> unifSample2 = runif.sample(5000);
ArrayList<Particle> system = new ArrayList<Particle>();
ArrayList<Float> initialCoordinates = runif.sample(2);
void setup() {
  //fullScreen();
  size(displayWidth, displayHeight);
  system.add(new Particle(5, (float) timeScale * millis(), null, initialCoordinates.get(0), initialCoordinates.get(1)));
}

void draw() {
  //for (int i = 0; i < 500; i++) {
  //  point(sample1.get(i), sample2.get(i));
    //point(unifSample1.get(i), unifSample2.get(i));
  //}
  background(0);
  for (Particle p1 : system) {
    p1.update(timeScale*millis());
    p1.display();
  }
  if (millis() % 200 < 20) {
    system.add(new Particle(random(5), (float) timeScale * millis(), null, random(400), random(400)));
  }
}