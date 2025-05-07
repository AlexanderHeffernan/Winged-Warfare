/**
 * This class represents enemy planes in the game.
 */
class EnemyPlane implements GameObject {
  private String name;
  private ArrayList<String> tags;
  private Transform transform;
  private int score = 50;
  private boolean leftOfScreen = false;
  private int timeBetweenShots = 50;
  private int currentTime = 90;
  
  ArrayList<PImage> sprites = new ArrayList<PImage>();
  private int frame = 0;
  
  // Constructor
  public EnemyPlane (String name, PVector pos) {
    this.name = name;
    this.tags = new ArrayList<String>();
    this.tags.add("EnemyPlane");
    this.transform = new Transform(this);
    this.transform.position = pos;
    this.transform.velocity = new PVector(-worldSpeed*2,0);
    this.transform.size = new PVector(90, 42);
    this.sprites = planeSprites;
  }
  
  /**
   * Update method to handle the behaviour of the enemy plane.
   */
  public void update() {
    this.transform.update();
    
    // Check collisions
    for (GameObject collision : this.transform.getCollisions()) {
      if (collision.containsTag("Explosion")) {
        destroy(this);
      }
    }
    
    // Check if need to be destroy based on edge collisions
    ArrayList<String> edgeCollisions = this.transform.getEdgeCollisions();
    if (edgeCollisions.contains(LEFT)) {
      if (!leftOfScreen)
        leftOfScreen = true;
    }
    if (leftOfScreen && !this.transform.onScreen()) {
      destroy(this);
    }
      
    // Draw plane
    imageMode(CENTER);
    image(sprites.get(frame), this.transform.position.x, this.transform.position.y, 96, 48);
    
    // If enemy plane is in line with player
    if ((transform.position.y - 40 < player.transform.position.y && player.transform.position.y < transform.position.y + 40) && transform.position.x < width) {
      this.transform.velocity = new PVector(-worldSpeed*2,0);
      if (this.timeBetweenShots <= this.currentTime && this.transform.onScreen()) {
        createPlaneShot(new PVector(this.transform.position.x, this.transform.position.y, this.transform.position.z), false, 0);
        this.currentTime = 0; 
      }
      if (this.frame == 0) { this.frame = 1;
      } else { this.frame = 0; }
    }
    // If enemy plane is above player
    else if (transform.position.y - 40 > player.transform.position.y) {
      this.transform.velocity = new PVector(-worldSpeed*2,-worldSpeed/2); 
      if (this.frame == 3) { this.frame = 5; }
      else { this.frame = 4; }
    }
    // If enemy plane is below player
    else if (transform.position.y + 40 < player.transform.position.y) {
      this.transform.velocity = new PVector(-worldSpeed*2,worldSpeed/2);
      if (this.frame == 2) { this.frame = 3; }
      else { this.frame = 2; }      
    }
    this.currentTime++;
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
