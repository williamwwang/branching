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
  public boolean born;
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
  PShape edge;
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
    this.part = null;
    //this.part = createShape();
    if (parent == null) {
      this.generation = 1;
    } else {
      this.generation = parent.generation + 1;
    }
    ps.newParticles.add(this);
    //if (born && !hasChildren) {
    //  ps.createGeneration(this.generation);
    //}
    //generateChildren();
  }
  
  public void setX(float x) {
    this.x = x;
  }
  
  public void setY(float y) {
    this.y = y;
  }
  
  public void setCoordinates(float x, float y) {
    setX(x);
    setY(y);
    this.part = createShape(ELLIPSE, x, y, (float)ps.PARTICLE_WIDTH, (float)ps.PARTICLE_HEIGHT);
    addEdge();
  }
  
  public void addEdge() {
    edge = createShape();
    edge.beginShape();
    if (parent != null) {
      edge.vertex(parent.x, parent.y);
    }
    edge.vertex(x, y);
    edge.endShape(CLOSE);
  }
  
  public boolean hasShape() {
    return this.part != null;
  }
  public PShape getShape() {
    return this.part;
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
    // Probably not necessary - EDIT: necessary
    this.hasChildren = true;
    Queue<Float> birthTimes = generateChildrenTimes();
    children = new LinkedList<Particle>();
    int numChildren = birthTimes.size();
    // needs constants
    //float newX = this.generation * 5;
    // Each particle child space can take a certain capacity proportional to the number of particles in its generation
    // Children share the child space equally
    //float newY = this.generation * 2;
    while (birthTimes.peek() != null) {
      //Particle p = new Particle(5, birthTimes.poll(), this, newX, newY);
      float time = ps.rand.sample();
      Particle p = new Particle(ps, time, birthTimes.poll(), this);
      children.add(p);
    }
    numChildren = children.size();
  }

  public Queue<Float> generateChildrenTimes() {
    Queue<Float> birthTimes = new LinkedList<Float>();
    RNG waitingTimes = new RNG(new ExponentialDistribution(ps.lambda));
    float newBirthtime = waitingTimes.sample();
    float currentTime = millis() * (float) ps.TSCALE;
    while (newBirthtime <= this.initialLifetime) {
      birthTimes.add(currentTime + newBirthtime);
      newBirthtime += waitingTimes.sample();
    }
    return birthTimes;
  }
  
  public void update() {
    // TODO: change the timings, computer color, set this to alive when it is time
    if (!born && millis()*ps.TSCALE >= this.birthTime) {
      this.setBorn();
    } else if (isDead()) {
      this.part.setStroke(color(0, 0, 0));
      this.part.setFill(color(0, 0, 0));
      this.edge.setStroke(color(0, 0, 0));
      this.edge.setFill(color(0, 0, 0));
      return;
    }
    // The time this particle has been alive
    float timeElapsed = millis()*ps.TSCALE - this.birthTime;
    lifetime = initialLifetime - timeElapsed;
    computeColor(timeElapsed);
    this.part.setStroke(color(r, g, b));
    this.part.setFill(color(r, g, b));
    this.edge.setStroke(color(r, g, b));
    this.edge.setFill(color(r, g, b));
  }
  
  public void setBorn() {
    this.born = true;
    if (!hasChildren) {
      ps.createGeneration(this.generation);
    }
  }
  
  public void display() {
    if (isDead()) {
      return;
    }
    fill(this.r, this.g, this.b);
    ellipse(x, y, 50, 50);
  }
}