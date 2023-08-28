class PlaneShot implements GameObject {
  private String name;
  private ArrayList<String> tags;
  private Transform transform;
  private int score = 50;
  private int speed = 15;
  private int damage = 10;
  
  public PlaneShot (String name, boolean player, int angle) {
    this.name = name;
    this.tags = new ArrayList<String>();
    this.transform = new Transform(this);
    this.transform.position = new PVector(width+64, height-42);
    if (player) {
      this.transform.velocity = new PVector(-worldSpeed + speed, angle);
      this.tags.add("PlayerShot");
    } else {
      this.transform.velocity = new PVector(-worldSpeed - speed, angle);
      this.tags.add("EnemyShot");
    }
    this.transform.size = new PVector(12, 6);
    bulletSound.play();
  }
  
  public void update() {
    this.transform.update();
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
        destroy(this); 
      }
      if (collision.containsTag("Tank")) {
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
    
    if (this.transform.position.y >= height - 63)
      destroy(this);
    
    if (!this.transform.onScreen()) {
      destroy(this);
    }
    
    fill(0);
    rectMode(CENTER);
    rect(this.transform.position.x, this.transform.position.y, this.transform.size.x, this.transform.size.y); 
  }
  
  public boolean containsTag(String tag) {
    return this.tags.contains(tag);
  }
  
  public String getName() {
    return this.name;
  }
  
  public ArrayList<String> getTags() {
    return this.tags;
  }
  
  public Transform getTransform() {
    return this.transform;
  }
  
  public int getScore() {
    return this.score;
  }
  
  public int getDamage() {
    return this.damage;
  }
  
  public void takeDamage(int damage) {
    return;
  }
}
