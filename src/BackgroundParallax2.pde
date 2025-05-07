/**
 * This class represents the second element of the paralalx background.
 */
class BackgroundParallax2 implements GameObject {
  // Private variables
  private String name;
  private ArrayList<String> tags;
  private Transform transform;
  private boolean hasExtended = false;
  private boolean leftOfScreen = false;
  private int score = 0;
  
  PImage sprite;
  
  // Constructor
  public BackgroundParallax2 (String name) {
    this.name = name;
    this.tags = new ArrayList<String>();
    this.tags.add("BackgroundParallax2");
    this.transform = new Transform(this);
    
    // Initial postitions depends on whether or not it
    // is the starting frame.
    if (startingFrame) { 
      this.transform.position = new PVector(width*1.2, height/3*2);
      this.sprite = backgroundParallax2OpeningSprite;
    }
    else { 
      this.transform.position = new PVector(width+996/2, height/3*2); 
      this.sprite = backgroundParallax2Sprite;
    }
      
    this.transform.velocity = new PVector(-worldSpeed/6,0);
    this.transform.size = new PVector(1000, 600);
    this.transform.collidable = false;
  }
  
  /**
   * Update method to ahndle background behaviour
   */
  public void update() {
    this.transform.update();
    ArrayList<String> edgeCollisions = this.transform.getEdgeCollisions();
    
    // Check if the background needs to extend
    if (!edgeCollisions.contains(RIGHT)) {
      if (!this.hasExtended) {
        this.hasExtended = true;
        createBackgroundParallax2();
      }
    }
    
    // Check if the background has moved left of the screen
    // and destroy it if needed.
    if (edgeCollisions.contains(LEFT)) {
      if (!leftOfScreen)
        leftOfScreen = true;
    }
    if (leftOfScreen && !this.transform.onScreen()) {
      destroy(this);
    }
    
    imageMode(CENTER);
    image(sprite, this.transform.position.x, this.transform.position.y, 1000, 600);
    //rect(this.transform.position.x, this.transform.position.y, this.transform.size.x, this.transform.size.y); 
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
