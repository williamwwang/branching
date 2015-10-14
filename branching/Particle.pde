import java.util.ArrayList;
import java.util.Queue;
import java.util.LinkedList;
import java.util.Comparator;
class Particle {
  // Constant
  public float initialLifetime;
  // Variable in time units
  public float lifetime;
  // When the particle was born, constant
  public float birthTime;
  public boolean dying;
  public int generation;
  public Particle parent;
  public Queue<Particle> children;
  public float x;
  public float y;
  // Red color component
  public int r = 0;
  // Green color component
  public int g = 255;
  // Blue color component
  public int b = 0;
  
  PShape part;
  ParticleSystem ps;
  
  // Coefficients for linear scaling of each color
  public float[] rCoef, gCoef, bCoef;
  
  public Particle(ParticleSystem ps, float lifetime, float birthTime, Particle parent, float x, float y) {
    this.ps = ps;
    this.initialLifetime = lifetime;
    this.lifetime = lifetime;
    this.birthTime = birthTime;
    this.parent = parent;
    this.dying = false;
    this.rCoef = new float[]{(float) -r/ lifetime, r};
    this.gCoef = new float[]{(float) -g/ lifetime, g};
    this.bCoef = new float[]{(float) -b/ lifetime, b};
    this.x = x;
    this.y = y;
    if (parent == null) {
      this.generation = 1;
    } else {
      this.generation = parent.generation + 1;
    }
    generateChildren();
  }
  
  public boolean isDead() {
    return lifetime <= 0;
  }
  
  public void computeColor(double timeElapsed) {
    this.r = max((int) (rCoef[0]*timeElapsed + rCoef[1]), 0);
    this.g = max((int) (gCoef[0]*timeElapsed + gCoef[1]), 0);
    this.b = max((int) (bCoef[0]*timeElapsed + bCoef[1]), 0);
  }
  
  public void generateChildren() {
    Queue<Float> birthTimes = generateChildrenTimes();
    children = new LinkedList<Particle>();
    int numChildren = birthTimes.size();
    // needs constants
    float newX = this.generation * 5;
    // Each particle child space can take a certain capacity proportional to the number of particles in its generation
    // Children share the child space equally
    float newY = this.generation * 2;
    while (birthTimes.peek() != null) {
      Particle p = new Particle(5, birthTimes.poll(), this, newX, newY);
      children.add(p);
    }
  }

  public Queue<Float> generateChildrenTimes() {
    Queue<Float> birthTimes = new LinkedList<Float>();
    RNG waitingTimes = new RNG(new ExponentialDistribution(ps.lambda));
    float newBirthtime = waitingTimes.sample();
    while (newBirthtime <= this.initialLifetime) {
      birthTimes.add(newBirthtime);
      newBirthtime += waitingTimes.sample();
    }
    return birthTimes;
  }
  
  public void update(double timeElapsed) {
    lifetime = initialLifetime - (float) (timeElapsed - birthTime);
    computeColor(timeElapsed - birthTime);
  }
  
  public void display() {
    if (isDead()) {
      return;
    }
    fill(this.r, this.g, this.b);
    ellipse(x, y, 50, 50);
  }
}