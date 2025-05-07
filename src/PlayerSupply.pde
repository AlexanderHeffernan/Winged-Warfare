class PlayerSupply implements GameObject {
  private String name;
  private ArrayList<String> tags;
  private Transform transform;
  private int score = 0;
  
  PImage sprite;
  
  // Cnostructor
  public PlayerSupply (String name) {
    this.name = name;
    this.tags = new ArrayList<String>();
    this.tags.add("PlayerSupply");
    this.transform = new Transform(this);
    
    // Set the initial position just below the player's position
    this.transform.position = new PVector(player.getTransform().position.x, player.getTransform().position.y+18);
    
    this.transform.velocity = new PVector(0,8);
    this.transform.size = new PVector(80, 80);
    this.sprite = supplyDropSprites.get(1);
    sound.playBombFallingSound();
  }
  
  /**
   * Update method to handle supply drop behaviour.
   */
  public void update() {
    this.transform.update();
    
    // Set image mode and siaply the supply drop sprite
    imageMode(CENTER);
    image(sprite, this.transform.position.x, this.transform.position.y, 84, 90);
    
    // Check if the supply drop has reached the ground
    if (this.transform.position.y >= height-90) {
      // Stop vertical momement and move horizontally with the world speed
      this.transform.velocity.y = 0;
      this.transform.velocity.x = -worldSpeed;
      
      // Indicate landing by changing sprite
      this.sprite = supplyDropSprites.get(2);
    }
    
    // Destroy the supply drop if it goes off-screen
    if (!this.transform.onScreen())
      destroy(this);
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
