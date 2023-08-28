/**
 * Transform class used to track position, velocity, size, whether or not to follow the mouse and collision of an object.
 * Contains default values for position, velocity and size of (0, 0). as well as to not follow the mouse.
 * Calculates the left-most (x), right-most (x), top-most (y), and the bottom-most (y) positions of the object/
 * If object has a velocity (is moving), checks for collisions with all other objects, and moves based on the resulting velocity.
 * Collisions tracked include hitting the sides of the window, and the sides (including corners) of all objects.
 * Contains bouncing functions, used when colliding with different objects and sides of the window.
 */
class Transform {
  public GameObject gameObject;
  public PVector position;
  public PVector velocity;
  public PVector size;
  
  public float left = 0f;
  public float right = 0f;
  public float top = 0f;
  public float bottom = 0f;
  public boolean collidable;
  
  /**
   * Constructor sets defaults position, velocity and size of (0, 0).
   * Also adds itself to the global objects arraylist.
   */
  public Transform (GameObject gameObject){
    this.position = new PVector(0, 0);
    this.velocity = new PVector(0, 0);
    this.size = new PVector(0, 0);
    this.gameObject = gameObject;
    this.collidable = true;
  }
  
  /**
   * Runs every frame, updating the edge position variables (left, right, top, and bottom).
   * If object has velocity, checks collisions and changes position.
   * If object follows mouse, change position to mouse position.
   */
  public void update(){
    this.updateEdgePositions();
    
    if(this.velocity.x != 0 || this.velocity.y != 0) {
      this.position.x += this.velocity.x; // Adds x velocity to x position.
      this.position.y += this.velocity.y; // Add y velocity to y position.
    }
  }
  
  /**
   * Updates all edge position variables (left, right, top, and bottom).
   * Is called in the update function.
   */
  private void updateEdgePositions() {
    this.left = this.position.x - this.size.x/2;
    this.right = this.position.x + this.size.x/2;
    this.top = this.position.y - this.size.y/2;
    this.bottom = this.position.y + this.size.y/2;
  }
  /**
   * Checks for collisions with the sides of the screen and all other objects.
   * If collision found, and changes in velocity is required, bounce function (out of bounceX and bounceY) is called.
   * Only bounces if there was no collision in the previous frame to prevent objects getting stuck in eachother.
   */
  public ArrayList<GameObject> getCollisions() {
    ArrayList<GameObject> collisions = new ArrayList<GameObject>();
    for(GameObject gameObject : gameObjects) { // Loop through all objects.
      Transform object = gameObject.getTransform();
      boolean collisionFound = false;
      if (object.collidable) {
        float distance = sqrt((this.position.x-object.position.x)*(this.position.x-object.position.x)+(this.position.y-object.position.y)*(this.position.y-object.position.y));
        if (distance <= 192) {
          if (object != this) { // If object isn't self.
            if(this.left > object.left && this.right < object.right) { // If vertically aligned with object.
              if(this.bottom >= object.top && this.bottom < object.bottom) { // Ff collide with top of object.
                // Top collision with object.
                collisionFound = true;
              } 
              else if(this.top <= object.bottom && this.top > object.top) { // If collide with bottom of object.
                // Bottom collision with object.
                collisionFound = true;
              }
            }
            else if(this.top > object.top - this.size.y/2 && this.bottom < object.bottom + this.size.y/2) { // Ff horizontally aligned with object.
              if(this.right >= object.left && this.right < object.right) { // If collide with left of object.
                // Left collision with object.
                collisionFound = true;
              }
              else if(this.left <= object.right && this.left > object.left) { // If collide with right of object.
                // Right collision with object.
                collisionFound = true;
              }
            }
            else if(this.bottom >= object.top && this.bottom < object.bottom) { // If colliding with top of object.
              if(this.right >= object.left && this.right < object.right) { // If colliding with left of object.
                // Top left collision with object.
                collisionFound = true;
              }
              else if(this.left <= object.right && this.left > object.left) { // If colliding with right object.
                // Top right collision with object.
                collisionFound = true;
              }
            }
            else if(this.top <= object.bottom && this.top > object.top) { // If colliding with bottom of object.
              if(this.right >= object.left && this.right < object.right) { // If colliding with left of object.
                // Bottom left collision with object.
                collisionFound = true;
              }
              else if(this.left <= object.right && this.left > object.left) { // If colliding with right of object.
                collisionFound = true;
              }
            }
          }
          if (collisionFound) { collisions.add(gameObject); }
        }
      }
    }
    return collisions;
  }
  
  public ArrayList<String> getEdgeCollisions() {
    ArrayList<String> edgesHit = new ArrayList<String>();
    if (this.left < 0) { edgesHit.add(LEFT); }
    if (this.right > width) { edgesHit.add(RIGHT); }
    if (this.top < 0) { edgesHit.add(TOP); }
    if (this.bottom > height) { edgesHit.add(BOTTOM); }
    return edgesHit;
  }
  
  public boolean onScreen() {
    return !(this.right < 0 || this.left > width || this.bottom < 0 || this.top > height);
  }
}
