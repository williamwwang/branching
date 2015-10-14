public class ParticleSystem {
  public float lambda;
  ArrayList<Particle> particles;
  
  PShape particleShape;
  // Maybe have an Exponential RNG?
  // Generates random lifetimes
  RNG rand;
  
  // i-th element is count in generation i + 1 (0-indexed -> 1-indexed)
  ArrayList<Integer> generationCount;
  /* Constants */
  // Maximum vertical space per generation
  int MAX_VSPACE = 20;
  // Initial Horizontal space for initial particle
  int INIT_HSPACE = 20;
  // Vertical padding
  int VPAD = 5;
  // Horizontal scaling factor: hspace_gen{x+1} = hspace_gen{x}*HSCALE
  double HSCALE = 1.2;
  // Time scaling factor: .001 (millis -> sec)
  double TSCALE = .001;
  
  public ParticleSystem(float lambda, Distribution dist) {
    this.lambda = lambda;
    this.rand = new RNG(dist);
    particles = new ArrayList<Particle>();
    particleShape = createShape(PShape.GROUP);
    generationCount = new ArrayList<Integer>();
    generationCount.add(1);
    Particle p = new Particle(this, rand.sample() * TSCALE, millis() * TSCALE, null, displayWidth / 2, VPAD + MAX_VSPACE);
    particles.add(p);
    particleShape.addChild(p.getShape());
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