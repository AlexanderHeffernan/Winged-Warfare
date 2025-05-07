class Tent implements GameObject {
  private String name;
  private ArrayList<String> tags;
  private Transform transform;
  private int score = 25;
  private boolean leftOfScreen = false;
  
  private boolean destroyed = false;
  
  PImage sprite;
  
  // Constructor
  public Tent (String name) {
    this.name = name;
    this.tags = new ArrayList<String>();
    this.tags.add("Tank");
    this.transform = new Transform(this);
    this.transform.position = new PVector(width+64, height-69);
    this.transform.velocity = new PVector(-worldSpeed,0);
    this.transform.size = new PVector(72, 36);
    sprite = tentSprites.get(0);
  }
  
  /**
   * Update method to handle tent movement and collisions.
   */
  public void update() {
    this.transform.update();
    if (!destroyed) {
      // Check collisions
      for (GameObject collision : this.transform.getCollisions()) {
        if (collision.containsTag("Explosion")) {
          totalScore += this.getScore();
          sprite = tentSprites.get(1);
          destroyed = true;
        }
      }
    }
    
    ArrayList<String> edgeCollisions = this.transform.getEdgeCollisions();
    if (edgeCollisions.contains(LEFT)) {
      if (!leftOfScreen)
        leftOfScreen = true;
    }
    
    // Destroy the tent if it goes off-screen
    if (leftOfScreen && !this.transform.onScreen()) {
      destroy(this);
    }
   
    // Render tent
    fill(0, 255, 0);
    imageMode(CENTER);
    image(sprite, this.transform.position.x, this.transform.position.y, 72, 36);
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
