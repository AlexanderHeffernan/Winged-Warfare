class BackgroundParallax1 implements GameObject {
  private String name;
  private ArrayList<String> tags;
  private Transform transform;
  private boolean hasExtended = false;
  private boolean leftOfScreen = false;
  private int score = 0;
  
  PImage sprite;
  
  public BackgroundParallax1 (String name) {
    this.name = name;
    this.tags = new ArrayList<String>();
    this.tags.add("BackgroundParallax1");
    this.transform = new Transform(this);
    if (startingFrame) { this.transform.position = new PVector(width/2, height/2); }
    else { this.transform.position = new PVector(width+996/2, height/2); }
      
    this.transform.velocity = new PVector(-worldSpeed/3,0);
    this.transform.size = new PVector(1000, 600);
    this.transform.collidable = false;
    this.sprite = backgroundParallax1Sprite;
  }
  
  public void update() {
    this.transform.update();
    ArrayList<String> edgeCollisions = this.transform.getEdgeCollisions();
    if (!edgeCollisions.contains(RIGHT)) {
      if (!this.hasExtended) {
        this.hasExtended = true;
        createBackgroundParallax1();
      }
    }
    if (edgeCollisions.contains(LEFT)) {
      if (!leftOfScreen)
        leftOfScreen = true;
    }
    if (leftOfScreen && !this.transform.onScreen()) {
      destroy(this);
    }
    
    imageMode(CENTER);
    image(sprite, this.transform.position.x, this.transform.position.y, 1000, 600);
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
