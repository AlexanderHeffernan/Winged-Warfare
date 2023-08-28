class EnemyPlane implements GameObject {
  private String name;
  private ArrayList<String> tags;
  private Transform transform;
  private int score = 100;
  private boolean leftOfScreen = false;
  private int timeBetweenShots = 80;
  private int currentTime = 75;
  
  ArrayList<PImage> sprites = new ArrayList<PImage>();
  private int frame = 0;
  
  public EnemyPlane (String name) {
    this.name = name;
    this.tags = new ArrayList<String>();
    this.tags.add("EnemyPlane");
    this.transform = new Transform(this);
    this.transform.position = new PVector(width, 20 + random(height/3*2));
    this.transform.velocity = new PVector(-worldSpeed*2,0);
    this.transform.size = new PVector(96, 48);
    this.sprites = planeSprites;
  }
  
  public void update() {
    this.transform.update();
    for (GameObject collision : this.transform.getCollisions()) {
      if (collision.containsTag("Explosion") || collision.containsTag("PlayerShot")) {
        createExplosion(this.transform.position);
        totalScore += this.getScore();
        destroy(this);
      }
    }
    
    ArrayList<String> edgeCollisions = this.transform.getEdgeCollisions();
    if (edgeCollisions.contains(LEFT)) {
      if (!leftOfScreen)
        leftOfScreen = true;
    }
    if (leftOfScreen && !this.transform.onScreen()) {
      destroy(this);
    }
    
    if (this.timeBetweenShots <= this.currentTime && this.transform.onScreen()) {
      createPlaneShot(new PVector(this.transform.position.x, this.transform.position.y, this.transform.position.z), false);
      this.currentTime = 0; 
    } else {
      this.currentTime++;
    }
      
    imageMode(CENTER);
    image(sprites.get(frame), this.transform.position.x, this.transform.position.y, 96, 48);
    if (this.frame == 0) {
      this.frame = 1;
    } else {
      this.frame = 0;
    }
  }
  
  public boolean containsTag(String tag) {
    return tags.contains(tag);
  }
  
  public String getName() {
    return name;
  }
  
  public ArrayList<String> getTags() {
    return tags;
  }
  
  public Transform getTransform() {
    return transform;
  }
  
  public int getScore() {
    return score;
  }
  
  public int getDamage() {
    return 0;
  }
  
  public void takeDamage(int damage) {
    return;
  }
}
