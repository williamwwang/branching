//import java.util.ArrayList;

public class RNG {
  
  public Function cdf;
  public Function pdf;
  public Function invcdf;
  
  public RNG(Distribution dist) {
    this.cdf = dist.cdf;
    this.pdf = dist.pdf;
    this.invcdf = dist.invcdf;
  }
  
  public Float sample() {
    if (invcdf != null) {
      return inverseCDFTransform(1).get(0);
    }
    if (pdf != null) {
      return rejectionSample(1).get(0);
    }
    return null;
  }
  public ArrayList<Float> sample(int n) {
    // Default to inverse cdf transform
    if (invcdf != null) {
      return inverseCDFTransform(n);
    }
    if (pdf != null) {
      return rejectionSample(n);
    }
    return null;
  }
  
  public ArrayList<Float> sample(int n, String method) {
    if (method.equals("inv")) {
      return inverseCDFTransform(n);
    } else {
      return rejectionSample(n);
    }
  }
  
  public ArrayList<Float> inverseCDFTransform(int n) {
    ArrayList<Float> sample = new ArrayList<Float>(n);
    for (int i = 0; i < n; i++) {
      float rand = random(1);
      float element = invcdf.apply(rand);
      sample.add(element);
    }
    return sample;
  }
  
  public ArrayList<Float> rejectionSample(int n) {
    return null;
  }
  
}