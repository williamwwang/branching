//import java.util.ArrayList;
//import java.util.Queue;
//import java.util.LinkedList;
//import java.util.Comparator;
class Particle {
  // Constant
  public float initialLifetime;
  // Variable in time units
  public float lifetime;
  // When the particle was born, constant
  public float birthTime;
  // When this particle will die
  public float deathTime;
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
  public QueueLite<Particle> children;
  // number of children
  public int numChildren;
  // Coordinates
  public float x;
  public float y;
  // Red color component
  public int r = 255;
  // Green color component
  public int g = 0;
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
    // MODE
    if (ps.mode == 1) {
      this.deathTime = birthTime + lifetime;
    } else if (ps.mode == 2 || ps.mode == 4) {
      if (parent == null) this.deathTime = birthTime + lifetime;
      else this.deathTime = parent.deathTime + lifetime;
    } else if (ps.mode == 3) {
      this.deathTime = birthTime + lifetime;
    }
    //  println("Death Time: " + deathTime);
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
    if (generation > 0 && ps.generationCount.get(generation - 1) > 50) {
      this.part = createShape(ELLIPSE, x, y, (float) ps.PARTICLE_WIDTH / 2, (float)ps.PARTICLE_HEIGHT / 2);
    } else if (generation > 0 && ps.generationCount.get(generation - 1) > 100) {
      this.part = createShape(ELLIPSE, x, y, (float) ps.PARTICLE_WIDTH / 5, (float)ps.PARTICLE_HEIGHT / 5);
    } else {
      this.part = createShape(ELLIPSE, x, y, (float)ps.PARTICLE_WIDTH, (float)ps.PARTICLE_HEIGHT);
    }
    this.part.setVisible(false);
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
    edge.setVisible(false);
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
    // MODE
    if ((ps.mode == 2 || ps.mode == 4) && timeElapsed < 0) {
      this.r = 0;
      this.g = 255;
      this.b = 255;
    } else {
      this.r = max((int) (rCoef[0]*timeElapsed + rCoef[1]), 0);
      this.g = max((int) (gCoef[0]*timeElapsed + gCoef[1]), 0);
      this.b = max((int) (bCoef[0]*timeElapsed + bCoef[1]), 0);
    }
  }
  
  public void generateChildren() {
    // Probably not necessary - EDIT: necessary
    this.hasChildren = true;
    QueueLite<Float> birthTimes = generateChildrenTimes();
    children = new LinkedListLite<Particle>();
    int numChildren = birthTimes.size();
    // needs constants
    //float newX = this.generation * 5;
    // Each particle child space can take a certain capacity proportional to the number of particles in its generation
    // Children share the child space equally
    //float newY = this.generation * 2;
    while (birthTimes.peek() != null) {
      //Particle p = new Particle(5, birthTimes.poll(), this, newX, newY);
      float time = 0;
      // MODE
      if (ps.mode == 3 || ps.mode == 4) {
        time = random(this.initialLifetime);
      } else {
        time = ps.rand.sample();
      }
      Particle p = new Particle(ps, time, birthTimes.poll(), this);
      children.add(p);
    }
    numChildren = children.size();
  }

  public QueueLite<Float> generateChildrenTimes() {
    QueueLite<Float> birthTimes = new LinkedListLite<Float>();
    RNG waitingTimes = new RNG(new ExponentialDistribution(ps.lambda));
    float waitingTime = waitingTimes.sample();
    // while(waitingTime <= this.lifetime) {// Causes different pattern, incorrect for the birth and assassination process
    while (waitingTime <= this.deathTime-this.birthTime) {
      birthTimes.add(this.birthTime + waitingTime);
      waitingTime += waitingTimes.sample();
    }
    return birthTimes;
  }
  
  public void update() {
    // TODO: change the timings, computer color, set this to alive when it is time
    if (!born && millis()*ps.TSCALE >= this.birthTime) {
      this.setBorn();
      this.part.setVisible(true);
      this.edge.setVisible(true);
    } else if (!born || isDead()) {
      /*this.part.setStroke(color(0, 0, 0));
      this.part.setFill(color(0, 0, 0));
      this.edge.setStroke(color(0, 0, 0));
      this.edge.setFill(color(0, 0, 0));*/
      this.part.setVisible(false);
      this.edge.setVisible(false);
      return;
    }
    // MODE
    if (ps.mode == 2 || ps.mode == 4) {
      float timeElapsed = 0;
      if (parent == null) timeElapsed = millis()*ps.TSCALE;
      else {
        timeElapsed = millis()*ps.TSCALE - parent.deathTime;
      }
      computeColor(timeElapsed);
      if (timeElapsed > 0) {
        lifetime = initialLifetime - timeElapsed;
      }
    }
    else {
      // The time this particle has been alive
      float timeElapsed = millis()*ps.TSCALE - this.birthTime;
      lifetime = initialLifetime - timeElapsed;
      computeColor(timeElapsed);
    }
    this.part.setStroke(color(r, g, b));
    this.part.setFill(color(r, g, b));
    if (parent == null) {
      this.edge.setStroke(color(0, 0, 0));
      this.edge.setFill(color(0, 0, 0));
    } else {
      this.edge.setStroke(color(parent.r, parent.g, parent.b));
      this.edge.setFill(color(parent.r, parent.g, parent.b));
    }
  }
  
  public void setBorn() {
    this.born = true;
    if (!hasChildren) {
      ps.createGeneration(this.generation + 1);
    }
  }
  
  public void die() {
    this.part.setVisible(false);
    this.edge.setVisible(false);
  }
  public void display() {
    if (isDead()) {
      return;
    }
    fill(this.r, this.g, this.b);
    ellipse(x, y, 50, 50);
  }
  
  public String toString() {
    return "Generation: " + generation + " Coordinates: [" + x + ", " + y + "]";
  }
}