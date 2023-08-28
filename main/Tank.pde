class Tank implements GameObject {
  private String name;
  private ArrayList<String> tags;
  private Transform transform;
  private int score = 50;
  private boolean leftOfScreen = false;
  private int timeBetweenShots = 100;
  private int currentTime = 0;
  
  private boolean destroyed = false;
  
  PImage sprite;
  
  public Tank (String name) {
    this.name = name;
    this.tags = new ArrayList<String>();
    this.tags.add("Tank");
    this.transform = new Transform(this);
    this.transform.position = new PVector(width+64, height-75);
    this.transform.velocity = new PVector(-worldSpeed,0);
    this.transform.size = new PVector(60, 48);
    sprite = tankSprites.get(0);
  }
  
  public void update() {
    this.transform.update();
    if (!destroyed) {
      for (GameObject collision : this.transform.getCollisions()) {
        if (collision.containsTag("Explosion")) {
          totalScore += this.getScore();
          sprite = tankSprites.get(1);
          destroyed = true;
        }
      }
    }
    
    ArrayList<String> edgeCollisions = this.transform.getEdgeCollisions();
    if (edgeCollisions.contains(LEFT)) {
      if (!leftOfScreen)
        leftOfScreen = true;
    }
    if (leftOfScreen && !this.transform.onScreen()) {
      destroy(this);
    }
    
    if (this.timeBetweenShots <= this.currentTime && this.transform.onScreen()) {
      createTankShot(new PVector(this.transform.position.x, this.transform.position.y, this.transform.position.z));
      this.currentTime = 0; 
    } else {
      this.currentTime++;
    }
    fill(0, 255, 0);
    imageMode(CENTER);
    image(sprite, this.transform.position.x, this.transform.position.y, 60, 48);
    //rect(this.transform.position.x, this.transform.position.y, this.transform.size.x, this.transform.size.y); 
  }
  
  public boolean containsTag(String tag) {
    return tags.contains(tag);
  }
  
  public String getName() {
    return name;
  }
  
  public ArrayList<String> getTags() {
    return tags;
  }
  
  public Transform getTransform() {
    return transform;
  }
  
  public int getScore() {
    return score;
  }
  
  public int getDamage() {
    return 0;
  }
  
  public void takeDamage(int damage) {
    return;
  }
}
