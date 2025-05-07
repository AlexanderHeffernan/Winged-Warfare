class TankShot implements GameObject {
  private String name;
  private ArrayList<String> tags;
  private Transform transform;
  private int score = 50;
  private int damage = 10;
  
  // Constructor
  public TankShot (String name) {
    this.name = name;
    this.tags = new ArrayList<String>();
    this.tags.add("TankShot");
    this.transform = new Transform(this);
    this.transform.position = new PVector(width+64, height-42);
    this.transform.velocity = new PVector(-worldSpeed + 5 - random(10), -4);
    this.transform.size = new PVector(6, 6);
  }
  
  /**
   * Update method to handle tank shot movement and collisions
   */
  public void update() {
    this.transform.update();
    for (GameObject collision : this.transform.getCollisions()) {
      // Destroy tank shot when colliding with explosion
      if (collision.containsTag("Explosion")) {
        destroy(this);
      } 
      
      // Inflict damage to player, and destroy shot, when hitting player
      if (collision.containsTag("Player")) {
        createExplosion(this.transform.position);
        collision.takeDamage(this.damage);
        destroy(this);
      }
      
      // Destroy the other shot and this shot when colliding with other shot
      if (collision.containsTag("PlayerShot") || collision.containsTag("EnemyShot")) {
        createExplosion(this.transform.position);
        destroy(collision);
        destroy(this);
      }
    }
    
    // Destroy the tank shot if it goes off-screen
    if (!this.transform.onScreen()) {
      destroy(this);
    }
    
    // Render shot
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
