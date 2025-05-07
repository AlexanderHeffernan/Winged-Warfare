/**
 * This class represents a tent objects controlled by the player's allies.
 */
class AlliedTent implements GameObject {
  // Private variables
  private String name;
  private ArrayList<String> tags;
  private Transform transform;
  private int score = 25;
  private boolean leftOfScreen = false;
  
  private boolean destroyed = false;
  
  private PImage sprite;
  
  private ArrayList<PImage> sprites;
  private float frame = 0;
  
  // Constructor
  public AlliedTent (String name) {
    this.name = name;
    this.tags = new ArrayList<String>();
    this.tags.add("AlliedTent");
    this.transform = new Transform(this);
    this.transform.position = new PVector(width+64, height-117);
    this.transform.velocity = new PVector(-worldSpeed,0);
    this.transform.size = new PVector(72, 36);
    sprites = alliedTentSprites;
    sprite = alliedTentSprites.get(0);
  }
  
  /**
   * Update method to handle tent behaviour
   */
  public void update() {
    this.transform.update();
    if (!destroyed) {
      // Cycle through animation frames
      frame += 0.08;
      if (round(frame) >= sprites.size() - 1) { frame = 0; }
      sprite = sprites.get(round(frame));
      // Check collisions
      for (GameObject collision : this.transform.getCollisions()) {
        if (collision.containsTag("PlayerSupply")) {
          collision.getTransform().collidable = false;
          totalScore += this.getScore();
          sprite = sprites.get(4);
          destroyed = true;
        }
      }
    }
    
    // Check edge of screen collisions
    ArrayList<String> edgeCollisions = this.transform.getEdgeCollisions();
    if (edgeCollisions.contains(LEFT)) {
      if (!leftOfScreen)
        leftOfScreen = true;
    }
    // Delete if left of screen
    if (leftOfScreen && !this.transform.onScreen()) {
      destroy(this);
    }
     
    // Draw sprite
    fill(0, 255, 0);
    imageMode(CENTER);
    image(sprite, this.transform.position.x, this.transform.position.y, 72, 144);
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
