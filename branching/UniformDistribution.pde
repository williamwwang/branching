class UniformDistribution extends Distribution {
  
  float a;
  float b;
  
  public UniformDistribution(float a, float b) {
    this.a = a;
    this.b = b;
    cdf = new UniformCDF();
    pdf = new UniformPDF();
    invcdf = new UniformInvCDF();
  }
  
  class UniformCDF implements Function {
    
    public float apply(float x) {
      if (x < a) return 0;
      else if (x <= b) return x/(b-a);
      else return 1;
    }
  }
  
  class UniformInvCDF implements Function {
    
    public float apply(float x) {
      return (b-a)*x;
    }
  }
  
  class UniformPDF implements Function {
    
    public float apply(float x) {
      if (a <= x && x <= b) {
        return 1/(b-a);
      }
      return 0;
    }
  }
}