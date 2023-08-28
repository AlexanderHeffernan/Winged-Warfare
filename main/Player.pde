class Player implements GameObject {
  private String name;
  private ArrayList<String> tags;
  private Transform transform;
  
  private boolean upKey = false;
  private boolean downKey = false;
  private boolean leftKey = false;
  private boolean rightKey = false;
  private int score = 0;
  private int maxHealth = 100;
  private int currentHealth = maxHealth;
  
  private boolean crashing = false;
  private boolean crashed = false;
  private int crashedTime = 0;
  
  ArrayList<PImage> sprites = new ArrayList<PImage>();
  private int frame = 0;
  
  public Player (String name) {
    this.name = name;
    this.tags = new ArrayList<String>();
    this.tags.add("Player");
    this.transform = new Transform(this);
    this.transform.position = new PVector(100, 250);
    this.transform.velocity = new PVector(0,0);
    this.transform.size = new PVector(90, 42);
    this.sprites = playerSprites;
  }
  
  public void update() {
    this.transform.update();
    int animationChange = 0;
    if (!this.crashing && !this.crashed) {
      for (GameObject collision : this.transform.getCollisions()) {
        if (collision.containsTag("Environment") || collision.containsTag("EnemyPlane")) {
          createExplosion(new PVector(this.transform.position.x, this.transform.position.y));
          this.crashing = true;
        }
        if (collision.containsTag("TankShot") || collision.containsTag("EnemyShot")) {
          createExplosion(new PVector(this.transform.position.x, this.transform.position.y));
          destroy(collision);
          this.takeDamage(collision.getDamage());
        }
      }
      
      if (this.transform.position.y >= height-71){ 
        createExplosion(new PVector(this.transform.position.x, this.transform.position.y));
        this.crashing = true;
      }
      
      if (upKey && !downKey && this.transform.position.y > this.transform.size.y / 2 + 80) {
        this.transform.velocity = new PVector(this.transform.velocity.x, -5);
        animationChange = 4;
      } else if (downKey && !upKey) {
        this.transform.velocity = new PVector(this.transform.velocity.x, 5);
        animationChange = 2;
      } else {
        this.transform.velocity = new PVector(this.transform.velocity.x, 0);
      }
      
      if (leftKey && !rightKey && this.transform.position.x > this.transform.size.x / 2 + 50)
        this.transform.velocity = new PVector(-5, this.transform.velocity.y);
      else if (rightKey && !leftKey && this.transform.position.x < 500)
        this.transform.velocity = new PVector(5, this.transform.velocity.y);
      else
        this.transform.velocity = new PVector(0, this.transform.velocity.y);
    }
    else if (this.crashing && !this.crashed) {
      this.currentHealth = 0;
      animationChange = 2;
      if (this.transform.position.y > height-71) {
        this.transform.velocity = new PVector(-worldSpeed, 0);
        this.transform.position.y = height-71;
        this.crashed = true;  
      } else {
        this.transform.velocity = new PVector(0, 3);
      }
    }
    else if (this.crashed) {
      this.crashedTime++;
      if (!this.transform.onScreen())
        destroy(this);
    }
      
    rectMode(CORNER);
    fill(255, 0, 0);
    stroke(0,0,0,0);
    rect(this.transform.position.x - (this.maxHealth)/2, this.transform.position.y - this.transform.size.y, this.maxHealth, 6);
    fill(0, 255, 0);
    rect(this.transform.position.x - (this.maxHealth)/2, this.transform.position.y - this.transform.size.y, this.currentHealth, 6);
      
    imageMode(CENTER);
    image(sprites.get(frame+animationChange), this.transform.position.x, this.transform.position.y, 96, 48);
    if (this.frame == 0 || this.crashed) {
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
  
  public void setDown(boolean value) {
    this.downKey = value;
  }
  
  public void setUp(boolean value) {
    this.upKey = value;
  }
  
  public void setLeft(boolean value) {
    this.leftKey = value;
  }
  
  public void setRight(boolean value) {
    this.rightKey = value;
  }
  
  public int getScore() {
    return score;
  }
  
  public void takeDamage(int damage) {
    this.currentHealth -= damage;
    if (this.currentHealth <= 0 && !this.crashing && !this.crashed) {
      createExplosion(new PVector(this.transform.position.x, this.transform.position.y));
      this.crashing = true;
    }
  }
  
  public int getDamage() {
    return 0;
  }
  
  public int getHealth() {
    return currentHealth;
  }
}
