/**
 * This class represents the ground object in the game.
 */
class Ground implements GameObject {
  private String name;
  private ArrayList<String> tags;
  private Transform transform;
  private boolean hasExtended = false;
  private boolean leftOfScreen = false;
  private int score = 0;
  
  PImage sprite;
  
  // Constructor
  public Ground (String name) {
    this.name = name;
    this.tags = new ArrayList<String>();
    this.tags.add("Ground");
    this.transform = new Transform(this);
    
    // Set the initial position of the object based
    // on whether or not it is the starting frame.
    if (startingFrame) { this.transform.position = new PVector(width/2, height-18); }
    else { this.transform.position = new PVector(width+1001/2, height-18); }
      
    this.transform.velocity = new PVector(-worldSpeed,0);
    this.transform.size = new PVector(1056, 102);
    this.transform.collidable = false;
    sprite = groundSprite;
  }
  
  /**
   * Updates the state and behaviour of the ground object.
   */
  public void update() {
    this.transform.update();
    ArrayList<String> edgeCollisions = this.transform.getEdgeCollisions();
    
    // Check if the ground object needs to be extended
    if (!edgeCollisions.contains(RIGHT)) {
      if (!this.hasExtended) {
        this.hasExtended = true;
        createGround();
      }
    }
    
    // Check if the ground object has moved off the left
    // side of the screen, and destroy it if needed.
    if (edgeCollisions.contains(LEFT)) {
      if (!leftOfScreen)
        leftOfScreen = true;
    }
    if (leftOfScreen && !this.transform.onScreen()) {
      destroy(this);
    }
    
    // Render the ground object.
    imageMode(CENTER);
    image(sprite, this.transform.position.x, this.transform.position.y, 1056, 102); 
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
