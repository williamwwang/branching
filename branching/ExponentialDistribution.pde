class ExponentialDistribution extends Distribution {
  
  public float lambda;
  
  public ExponentialDistribution(float lambda) {
    this.lambda = lambda;
    cdf = new ExponentialCDF();
    pdf = new ExponentialPDF();
    invcdf = new ExponentialInvCDF();
  }
  
  class ExponentialCDF implements Function {
    
    public float apply(float x) {
      if (x < 0) return 0;
      else return 1 - exp(-lambda*x);
    }
  }
  
  class ExponentialInvCDF implements Function {
    
    public float apply(float x) {
      return -1/lambda * log(1-x);
    }
  }
  
  class ExponentialPDF implements Function {
    
    public float apply(float x) {
      if (x < 0) return 0;
      return lambda * exp(-lambda * x);
    }
  }
}