class SupplyDrop implements GameObject {
  private String name;
  private ArrayList<String> tags;
  private Transform transform;
  private int score = 0;
  private boolean leftOfScreen = false;
  
  PImage sprite;
  
  // Constructor
  public SupplyDrop (String name) {
    this.name = name;
    this.tags = new ArrayList<String>();
    
    // Randomly determine the type of supply drop
    if (gameMode == GameMode.ATTACK) {
      if (Math.round(Math.random()*2) == 1) {
        this.tags.add("HealthDrop");
        this.sprite = supplyDropSprites.get(0);
      }
      else {
        this.tags.add("BombDrop");
        this.sprite = supplyDropSprites.get(1);
      }
    } else {
      if (Math.round(Math.random()*3) == 1) {
        this.tags.add("HealthDrop");
        this.sprite = supplyDropSprites.get(0);
      }
      else {
        this.tags.add("BombDrop");
        this.sprite = supplyDropSprites.get(1);
      }
    }
    
    this.tags.add("SupplyDrop");
    this.transform = new Transform(this);
    this.transform.position = new PVector((int)(width/3*2 + Math.random()*width/2), -90);
    this.transform.velocity = new PVector(-worldSpeed,4);
    this.transform.size = new PVector(80, 80);
  }
  
  /**
   * Update method to handle supply drop movement and collisions.
   */
  public void update() {
    this.transform.update();
    
    // Check if the supply drop has reached the ground
    if (this.transform.position.y >= height-90) {
      this.transform.velocity.y = 0;
      // Indicate landing by changing sprite
      this.sprite = supplyDropSprites.get(2);
    }
    
    ArrayList<String> edgeCollisions = this.transform.getEdgeCollisions();
    if (edgeCollisions.contains(LEFT)) {
      if (!leftOfScreen)
        leftOfScreen = true;
    }
    
    // If the supply drop has moved off the screen, destroy
    if (leftOfScreen && !this.transform.onScreen()) {
      destroy(this);
    }
    
    // Render the supply drop
    imageMode(CENTER);
    image(sprite, this.transform.position.x, this.transform.position.y, 84, 90);
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
