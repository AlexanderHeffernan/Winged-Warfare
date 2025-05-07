/**
 * This class represents a shot fired by a player or enemy plane in the game.
 */
class PlaneShot implements GameObject {
  private String name;
  private ArrayList<String> tags;
  private Transform transform;
  private int score = 50;
  private int speed = 15;
  private int damage = 10;
  
  // Constructor
  public PlaneShot (String name, boolean player, int angle) {
    this.name = name;
    this.tags = new ArrayList<String>();
    this.transform = new Transform(this);
    this.transform.position = new PVector(width+64, height-42);
    
    // Set velocity based on whether the shot is from a player or enemy
    if (player) {
      this.transform.velocity = new PVector(-worldSpeed + speed, angle);
      this.tags.add("PlayerShot");
    } else {
      this.transform.velocity = new PVector(-worldSpeed - speed, angle);
      this.tags.add("EnemyShot");
    }
    this.transform.size = new PVector(12, 6);
    sound.playBulletSound();
  }
  
  /**
   * Updates the position and behaviour of the PlaneShot.
   */
  public void update() {
    this.transform.update();
    
    // Check for collisions with various gameObjects.
    for (GameObject collision : this.transform.getCollisions()) {
      if (collision.containsTag("Explosion")) {
        destroy(this);
      }
      
      if (collision.containsTag("Player") && this.containsTag("EnemyShot")) {
        createExplosion(this.transform.position);
        collision.takeDamage(this.damage);
        destroy(this); 
      }
      
      if (collision.containsTag("EnemyPlane") && this.containsTag("PlayerShot")) {
        createExplosion(this.transform.position);
        totalScore += collision.getScore();
        destroy(collision);
        destroy(this); 
      }
      
      if (collision.containsTag("Tank") || collision.containsTag("Tent")) {
        createExplosion(this.transform.position);
        destroy(this); 
      }
      
      if (collision.containsTag("PlayerShot") || collision.containsTag("EnemyShot")) {
        createExplosion(this.transform.position);
        destroy(collision);
        destroy(this); 
      }
      
      if (collision.containsTag("TankShot")) {
        createExplosion(this.transform.position);
        destroy(collision);
        destroy(this);
      }
    }
    
    // Check if the shot goes out of bounds.
    if (this.transform.position.y >= height - 60) {
      destroy(this);
    }
    
    // Check if the shot is no longer on screen.
    if (!this.transform.onScreen()) {
      destroy(this);
    }
    
    // Render the shot
    fill(0);
    rectMode(CENTER);
    rect(this.transform.position.x, this.transform.position.y, this.transform.size.x, this.transform.size.y); 
  }
  
  // Functions to implement gameObject
  
  public boolean containsTag(String tag) { return this.tags.contains(tag); }
  public String getName() { return this.name; }  
  public ArrayList<String> getTags() { return this.tags; }
  public Transform getTransform() { return this.transform; }
  public int getScore() { return this.score; }
  public int getDamage() { return this.damage; }  
  public void takeDamage(int damage) { return; }
}
