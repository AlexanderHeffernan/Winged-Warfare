class ObjectGenerator {
  private float waitTime = 0.15;
  private int currentTime = 0;
  public ObjectGenerator () {
    
  }
  
  public void update() {
    currentTime++;
    if (currentTime >= waitTime*100) {
      float random = random(100);
      if (0 <= random && random < 60) { createTree(); }
      else if (60 <= random && random <= 65) { createTank(); }
      currentTime = 0;
    }
  }
}
