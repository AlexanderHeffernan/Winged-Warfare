/**
 * This class represents a bomb GameObject that falls
 * from the player and can explode on collision.
 * It implements the GameObject interface for game interaction.
 */
class Bomb implements GameObject {
  // Private variables
  private String name;
  private ArrayList<String> tags;
  private Transform transform;
  private int score = 0;
  private boolean hasExploded = false;
  
  PImage sprite;
  
  // Constructor
  public Bomb (String name) {
    this.name = name;
    this.tags = new ArrayList<String>();
    this.tags.add("Bomb");
    this.transform = new Transform(this);
    
    // Initla position is just below player
    this.transform.position = new PVector(player.getTransform().position.x, player.getTransform().position.y+18);
    this.transform.velocity = new PVector(0,8);
    this.transform.size = new PVector(24, 48);
    this.sprite = bombSprite;
    sound.playBombFallingSound();
  }
  
  /**
   * Update method to handle bomb behaviour.
   */
  public void update() {
    this.transform.update();
    
    // Draw the bomb's sprite
    imageMode(CENTER);
    image(sprite, this.transform.position.x, this.transform.position.y, 24, 48);
    
    // Check for collisions
    for (GameObject collision : this.transform.getCollisions()) {
      if (!this.hasExploded) {
        if (collision.containsTag("Ground")) {
          this.explode();
        }
        if (collision.containsTag("EnemyPlane")) {
          this.explode();
          totalScore += collision.getScore();
          destroy(collision);
        }
      }
    }
    
    // If bomb has reached ground level, explode.
    if (this.transform.position.y >= height - 81)
      this.explode();
    
    // If no longer onscreen, destroy.
    if (!this.transform.onScreen())
      destroy(this);
  }
  
  /**
   * Method to handle bomb explosion
   */
  private void explode() {
    createExplosion(this.transform.position);
    this.hasExploded = true;
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
