import java.util.Queue;

public class ParticleSystem {
  public float lambda;
  ArrayList<Particle> particles;
  
  PShape particleShape;
  // Maybe have an Exponential RNG?
  // Generates random lifetimes
  RNG rand;
  
  // i-th element is count in generation i + 1 (0-indexed -> 1-indexed)
  ArrayList<Integer> generationCount;
  
  // i-th element is count in generation i + 1 (0-indexed -> 1-indexed)
  ArrayList<Queue<Particle>> generationQueue;

  /* Constants */
  // Height of particle
  double PARTICLE_HEIGHT = 20;
  // Width of particle
  double PARTICLE_WIDTH = 20;
  // Vertical padding
  double VPAD = 5;
  // Vertical space of connections (edges)
  double EDGE_HEIGHT = 10;
  // Horizontal scaling factor: hspace_gen{x+1} = hspace_gen{x}*HSCALE
  //double HSCALE = 1.2;
  // Time scaling factor: .001 (millis -> sec)
  double TSCALE = .001;
  
  public ParticleSystem(float lambda, Distribution dist) {
    this.lambda = lambda;
    this.rand = new RNG(dist);
    particles = new ArrayList<Particle>();
    particleShape = createShape(PShape.GROUP);
    
    generationCount = new ArrayList<Integer>();
    generationCount.add(1);
    
    // Create the generation queue
    generationQueue = new ArrayList<Queue<Particle>>();
    Queue<Particle> firstGen = new Queue<Particle>();
    Particle p = new Particle(this, rand.sample() * TSCALE, millis() * TSCALE, null);
    firstGen.add(p);
    generationQueue.add(0, firstGen);
    particles.add(p);
    particleShape.addChild(p.getShape());
  }
  
  // Creates the i-th generation, 1-indexed.
  public void createGeneration(int i) {
    Queue<Particle> thisGeneration = generationQueue.get(i - 1);
    if (thisGeneration == null) {
      return;
    }
    Queue<Particle> nextGeneration = new Queue<Particle>();
    Particle p = thisGeneration.poll();
    while (p != null) {
      p.generateChildren();
      for (Particle child : p.children) {
        nextGeneration.add(child);
      }
      p = thisGeneration.poll();
    }
    generationQueue.add(i, nextGeneration);
    generationCount.add(nextGeneration.size());
    setChildCoordinates(i);
  }
  
  public void setChildCoordinates(int i) {
    // Look at number of children in generation to see how much space this particle can allocate
    // Possible bug: int division?
    // double totalSpace = displayWidth / ps.generationCount.get(this.generation);
    // double spacePerChild = totalSpace / this.numChildren;
    double spacePerChild = displayWidth / (ps.generationCount.get(i) + 1);
    // x-coordinates
    double x = 0;
    // y-coordinates
    double y = VPAD + (i - 1) * (PARTICLE_HEIGHT + EDGE_HEIGHT) + PARTICLE_HEIGHT / 2;
    Queue<Particle> thisGeneration = generationQueue.get(i);
    for (Particle p : thisGeneration) {
      x += spacePerChild;
      p.setX(x);
      p.setY(y);
    }
  }
  
  void update() {
    for (Particle p: particles) {
      p.update();
    }
  }
  
  void display() {
    shape(particleShape);
  }
}