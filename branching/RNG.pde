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
  
  public FloatLite sample() {
    if (invcdf != null) {
      return inverseCDFTransform(1).get(0);
    }
    if (pdf != null) {
      return rejectionSample(1).get(0);
    }
    return null;
  }
  public ArrayList<FloatLite> sample(int n) {
    // Default to inverse cdf transform
    if (invcdf != null) {
      return inverseCDFTransform(n);
    }
    if (pdf != null) {
      return rejectionSample(n);
    }
    return null;
  }
  
  public ArrayList<FloatLite> sample(int n, String method) {
    if (method.equals("inv")) {
      return inverseCDFTransform(n);
    } else {
      return rejectionSample(n);
    }
  }
  
  public ArrayList<FloatLite> inverseCDFTransform(int n) {
    ArrayList<FloatLite> sample = new ArrayList<FloatLite>(n);
    for (int i = 0; i < n; i++) {
      float rand = random(1);
      float element = invcdf.apply(rand);
      sample.add(new FloatLite(element));
    }
    return sample;
  }
  
  public ArrayList<FloatLite> rejectionSample(int n) {
    return null;
  }
  
}