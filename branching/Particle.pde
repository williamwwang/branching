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
  // If this particle can die
  public boolean canDie;
  // If this particle has been born
  public boolean isAlive;
  // If this particle already knows its children
  public boolean hasChildren;
  // The current generation, 1-indexed
  public int generation;
  // Parent particle, needs this to keep track of when it is at risk
  public Particle parent;
  // Children to process
  public Queue<Particle> children;
  // number of children
  public int numChildren;
  // Coordinates
  public float x;
  public float y;
  // Red color component
  public int r = 0;
  // Green color component
  public int g = 255;
  // Blue color component
  public int b = 0;
  
  // PShape graphics
  PShape part;
  // Can contribute towards particle system fields
  ParticleSystem ps;
  
  // Coefficients for linear scaling of each color
  public float[] rCoef, gCoef, bCoef;
  
  public Particle(ParticleSystem ps, float lifetime, float birthTime, Particle parent) {
    this.ps = ps;
    this.initialLifetime = lifetime;
    this.lifetime = lifetime;
    this.birthTime = birthTime;
    this.parent = parent;
    this.canDie = false;
    this.rCoef = new float[]{(float) -r/ lifetime, r};
    this.gCoef = new float[]{(float) -g/ lifetime, g};
    this.bCoef = new float[]{(float) -b/ lifetime, b};
    if (parent == null) {
      this.generation = 1;
    } else {
      this.generation = parent.generation + 1;
    }
    if (isAlive && !hasChildren) {
      ps.createGeneration(this.generation);
    }
    //generateChildren();
  }
  
  public void setX(float x) {
    this.x = x;
  }
  
  public void setY(float y) {
    this.y = y;
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
    // Probably not necessary
    this.hasChildren = true;
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
    numChildren = children.size();
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
    // TODO: change the timings, computer color, set this to alive when it is time
    lifetime = initialLifetime - (float) (timeElapsed - birthTime);
    computeColor(timeElapsed - birthTime);
  }
  
  public void setAlive() {
    this.isAlive = true;
  }
  
  public void display() {
    if (isDead()) {
      return;
    }
    fill(this.r, this.g, this.b);
    ellipse(x, y, 50, 50);
  }
}