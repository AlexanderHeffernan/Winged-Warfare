/**
 * This class represents the game background.
 * It is a non-collidable, scrolling element used to
 * create the illusion of movement.
 */
class Background implements GameObject {
  // Private variables
  private String name;
  private ArrayList<String> tags;
  private Transform transform;
  private boolean hasExtended = false;
  private boolean leftOfScreen = false;
  private int score = 0;
  
  PImage sprite;
  
  /**
   * Constructor for background
   */
  public Background (String name) {
    this.name = name;
    this.tags = new ArrayList<String>();
    this.tags.add("Background");
    this.transform = new Transform(this);
    
    // Different starting positions depending on if 
    // it's the starting frame.
    if (startingFrame) { this.transform.position = new PVector(width/2, height/2); }
    else { this.transform.position = new PVector(width+996/2, height/2); }
      
    this.transform.velocity = new PVector(-worldSpeed/10,0);
    this.transform.size = new PVector(1000, 600);
    this.transform.collidable = false;
    this.sprite = backgroundSprite;
  }
  
  /**
   * Update method to handle background behaviour.
   */
  public void update() {
    this.transform.update();
    ArrayList<String> edgeCollisions = this.transform.getEdgeCollisions();
    
    // Check if the background needs to extend
    if (!edgeCollisions.contains(RIGHT)) {
      if (!this.hasExtended) {
        this.hasExtended = true;
        createBackground();
      }
    }
    
    // Check if the background has moved left of the screen
    // and destroy it if necessary.
    if (edgeCollisions.contains(LEFT)) {
      if (!leftOfScreen)
        leftOfScreen = true;
    }
    if (leftOfScreen && !this.transform.onScreen()) {
      destroy(this);
    }
    
    imageMode(CENTER);
    image(sprite, this.transform.position.x, this.transform.position.y, 1000, 600); 
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
