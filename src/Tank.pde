class Tank implements GameObject {
  private String name;
  private ArrayList<String> tags;
  private Transform transform;
  private int score = 100;
  private boolean leftOfScreen = false;
  
  // Variables to track shooting
  private int timeBetweenShots = 100;
  private int currentTime = 0;
  
  private boolean destroyed = false;
  
  PImage sprite;
  
  // Constructor
  public Tank (String name) {
    this.name = name;
    this.tags = new ArrayList<String>();
    this.tags.add("Tank");
    this.transform = new Transform(this);
    this.transform.position = new PVector(width+64, height-75);
    this.transform.velocity = new PVector(-worldSpeed,0);
    this.transform.size = new PVector(72, 36);
    sprite = tankSprites.get(0);
  }
  
  /**
   * Update method to handle tank movement, collisions, and shooting
   */
  public void update() {
    this.transform.update();
    if (!destroyed) {
      // Check for collisions with explosions, which destroy the tank
      for (GameObject collision : this.transform.getCollisions()) {
        if (collision.containsTag("Explosion")) {
          totalScore += this.getScore();
          // Change sprite to indicate destroyed
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
    
    // If the tank has moved off the screen, destroy
    if (leftOfScreen && !this.transform.onScreen()) {
      destroy(this);
    }
    
    if (!destroyed) {
      // Handle tank shooting at regular intervals
      if (this.timeBetweenShots <= this.currentTime && this.transform.onScreen()) {
        createTankShot(new PVector(this.transform.position.x, this.transform.position.y, this.transform.position.z));
        this.currentTime = 0; 
      } else {
        this.currentTime++;
      }
    }
    
    // Render tank
    fill(0, 255, 0);
    imageMode(CENTER);
    image(sprite, this.transform.position.x, this.transform.position.y, 60, 48); 
  }
  
  // Functions to implement gameObject
  
  public boolean containsTag(String tag) { return tags.contains(tag); }  
  public String getName() { return name; }  
  public ArrayList<String> getTags() { return tags; }  
  public Transform getTransform() { return transform; }  
  public int getScore() { return score; }
  public int getDamage() { return 0; }  
  public void takeDamage(int damage) { return; }
}
