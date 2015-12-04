//import java.util.Queue;
//import java.util.LinkedList;
//import java.util.PriorityQueue;
//import java.util.Comparator;

public class ParticleSystem {
  public float lambda;
  // Safety net
  public int MAX_CAPACITY = 3000;
  public boolean maxCapacityReached = false;
  public boolean simulationDone = false;
  public boolean result;
  // DO NOT CHANGE WHILE ITERATING
  // ArrayList<Particle> particles;
  QueueLite<Particle> particles;
  
  // DO NOT ITERATE THROUGH ME UNTIL UPDATE
  QueueLite<Particle> newParticles;
  
  //PShape particleShape;
  // Maybe have an Exponential RNG?
  // Generates random lifetimes
  RNG rand;
  
  // i-th element is count in generation i + 1 (0-indexed -> 1-indexed)
  ArrayList<Integer> generationCount;
  
  // i-th element is count in generation i + 1 (0-indexed -> 1-indexed)
  ArrayList<QueueLite<Particle>> generationQueue;

  /* Constants */
  // Height of screen
  double simHeight;
  // Width of screen
  double simWidth;
  // Height of particle
  double PARTICLE_HEIGHT = 10;
  // Width of particle
  double PARTICLE_WIDTH = 10;
  // Vertical padding
  double VPAD = 5;
  // Vertical space of connections (edges)
  double EDGE_HEIGHT = 30;
  // Horizontal scaling factor: hspace_gen{x+1} = hspace_gen{x}*HSCALE
  //double HSCALE = 1.2;
  // Time scaling factor: .001 (millis -> sec)
  float TSCALE = .001;
  
  // Modes:
  // 1: Galton-Watson
  // 2: Birth-and-Assassination
  // 3: Conditioning (T_0 = c, T_x ~ Unif(0, T_{x-1}) (x > 0))
  // 4: Conditioning with birth-and-assassination
  int mode;
  
  public ParticleSystem(float lambda, Distribution dist, int mode, float constant, double simWidth, double simHeight) {
    // Possibly move this to branching
    ellipseMode(CENTER);
    colorMode(RGB, 255, 255, 255);
    this.lambda = lambda;
    this.rand = new RNG(dist);
    this.mode = mode;
    this.simWidth = simWidth;
    this.simHeight = simHeight;
    // particles = new ArrayList<Particle>();
    particles = new PriorityQueueLite<Particle>(100, new ParticleDeathComparator());
    //particleShape = createShape(PShape.GROUP);
    
    generationCount = new ArrayList<Integer>();
    generationCount.add(1);
    
    newParticles = new LinkedListLite<Particle>();
    // Create the generation queue
    generationQueue = new ArrayList<QueueLite<Particle>>();
    QueueLite<Particle> firstGen = new LinkedListLite<Particle>();
    Particle p = null;
    // MODE
    if (mode == 3 || mode == 4) {
      p = new Particle(this, constant, millis() * TSCALE, null);
    } else {
      p = new Particle(this, rand.sample(), millis() * TSCALE, null);
    }
    p.setCoordinates((float) simWidth / 2, (float) VPAD + (float) PARTICLE_HEIGHT / 2);
    firstGen.add(p);
    println("First particle lifetime: " + p.lifetime);
    generationQueue.add(0, firstGen);
    particles.add(p);
    //particleShape.addChild(p.getShape());
  }
  
  // Creates the i-th generation, 1-indexed.
  public void createGeneration(int i) {
    println("Generation: " + i);
    QueueLite<Particle> previousGeneration = generationQueue.get(i - 2);
    if (previousGeneration == null) {
      return;
    }
    QueueLite<Particle> nextGeneration = new LinkedListLite<Particle>();
    Particle p = previousGeneration.poll();
    while (p != null) {
      p.generateChildren();
      IteratorLite<Particle> iter = p.children.iterator();
      while (iter.hasNext()) {
        Particle child = iter.next();
        nextGeneration.add(child);
      }
      p = previousGeneration.poll();
    }
    generationQueue.add(i - 1, nextGeneration);
    generationCount.add(nextGeneration.size());
    setChildCoordinates(i);
  }
  
  public void setChildCoordinates(int i) {
    // Look at number of children in generation to see how much space this particle can allocate
    // Possible bug: int division?
    // double totalSpace = displayWidth / ps.generationCount.get(this.generation);
    // double spacePerChild = totalSpace / this.numChildren;
    println("Number in generation:" + generationCount.get(i-1));
    double spacePerChild = simWidth / (generationCount.get(i - 1) + 1);
    if (spacePerChild == 0) maxCapacityReached = true;
    // x-coordinates
    float x = 0;
    // y-coordinates
    float y = (float) (VPAD + (i - 1) * (PARTICLE_HEIGHT + EDGE_HEIGHT) + PARTICLE_HEIGHT / (float) 2);
    if (y > simHeight) maxCapacityReached = true;
    QueueLite<Particle> thisGeneration = generationQueue.get(i - 1);
    IteratorLite<Particle> iter = thisGeneration.iterator();
    while (iter.hasNext()) {
      Particle p = iter.next();
      x += spacePerChild;
      p.setCoordinates(x, y);
    }
  }
  
  void update() {
    //println("Iter has next");
    //for (Particle part: particles) {
    //  part.update();
    //}

    IteratorLite<Particle> iter = particles.iterator();
    while (iter.hasNext()) {
      Particle part = iter.next();
      part.update();
    }

    Particle p = particles.peek();
    float currTime = millis() * TSCALE;
    /*if (p != null) {
      println("Death Time: " + p.deathTime);
      println("Current Time: " + currTime);
    }*/
    while (p != null && p.deathTime <= currTime) {
      p.die();
      particles.poll();
      p = particles.peek();
    }
    // Add all new particles
    if (particles.size() == 0) {
      simulationDone = true;
      if (maxCapacityReached) result = true;
      else result = false;
    }
    if (particles.size() >= MAX_CAPACITY) {
      println("Max capacity reached! " + particles.size());
      maxCapacityReached = true;
      return;
    }
    if (generationCount.size() >= 32) {
      println("Max generation reached: " + generationCount.size());
      return;
    }
    if (maxCapacityReached) return;
    p = newParticles.poll();
    while (p != null) {
      particles.add(p);
      //particleShape.addChild(p.getShape());
      //particleShape.addChild(p.edge);
      p = newParticles.poll();
    }

  }
  
  void display() {
    // shape(particleShape);
    // TODO: loop through all particles and draw manually given their attributes
    IteratorLite<Particle> iter = particles.iterator();
    while (iter.hasNext()) {
      Particle part = iter.next();
      part.display();
    }
  }
  
  class ParticleDeathComparator implements ComparatorLite<Particle> {
    // p1 < p2 if p1 death time is after p2 death time
    public int compare(Particle p1, Particle p2) {
      if (p1.deathTime < p2.deathTime) return -1;
      if (p1.deathTime > p2.deathTime) return 1;
      return 0;
    }
  }
}