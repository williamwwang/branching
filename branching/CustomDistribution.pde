class CustomDistribution extends Distribution {
  
  public CustomDistribution() {
    cdf = new CustomCDF();
    pdf = new CustomPDF();
    invcdf = new CustomInvCDF();
  }
  
  class CustomCDF implements Function {
    
    public float apply(float x) {
      if (x < 0) return 0;
      else if (x > 1) return 1;
      else return x*x*x;
    }
  }
  
  class CustomInvCDF implements Function {
    
    public float apply(float x) {
      return (float)Math.pow(x, (double) 1/3);
    }
  }
  
  class CustomPDF implements Function {
    
    public float apply(float x) {
      if (x < 0) return 0;
      if (x > 1) return 0;
      return 3*x*x;
    }
  }
}