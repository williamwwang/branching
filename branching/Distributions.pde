class ConstantDistribution extends Distribution {
  
  public float c;
  
  public ConstantDistribution(float c) {
    this.c = c;
    cdf = new ConstantCDF();
    pdf = new ConstantPDF();
    invcdf = new ConstantInvCDF();
  }
  
  class ConstantCDF implements Function {
    
    public float apply(float x) {
      if (x < 0) return 0;
      else if (x > 1) return 1;
      else return x*x*x;
    }
  }
  
  class ConstantInvCDF implements Function {
    
    public float apply(float x) {
      return c;
    }
  }
  
  class ConstantPDF implements Function {
    
    public float apply(float x) {
      if (x < 0) return 0;
      if (x > 1) return 0;
      return 3*x*x;
    }
  }
}

//#############################################

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

//#############################################

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

//#############################################

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
      return (b-a) * x + a;
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