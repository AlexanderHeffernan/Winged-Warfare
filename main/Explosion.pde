class Explosion implements GameObject {
  private String name;
  private ArrayList<String> tags;
  private Transform transform;
  private int score = 0;
  
  ArrayList<PImage> sprites;
  private int frame = 0;
  
  public Explosion (String name) {
    this.name = name;
    this.tags = new ArrayList<String>();
    this.tags.add("Explosion");
    this.transform = new Transform(this);
    this.transform.position = new PVector(player.getTransform().position.x, player.getTransform().position.y);
    this.transform.velocity = new PVector(-worldSpeed,0);
    this.transform.size = new PVector(66, 66);
    this.sprites = explosionSprites;
    explosionSound.play();
  }
  
  public void update() {
    frame++;
    if (frame > 13) {
      destroy(this);
    } else {
      this.transform.update();
      fill(0, 255, 0);
      imageMode(CENTER);
      image(sprites.get((int)(frame/2)), this.transform.position.x, this.transform.position.y, 66, 66);
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
