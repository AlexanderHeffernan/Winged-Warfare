public ArrayList<GameObject> gameObjects = new ArrayList<GameObject>();
public ArrayList<GameObject> toRemove = new ArrayList<GameObject>();
public ArrayList<GameObject> toAdd = new ArrayList<GameObject>();

public float worldSpeed = 4;
public int totalScore = 0;
public boolean pauseToggle = false;

public static final String LEFT = "left";
public static final String RIGHT = "right";
public static final String TOP = "top";
public static final String BOTTOM = "bottom";

ArrayList<PImage> treeSprites = new ArrayList<PImage>();
ArrayList<PImage> tankSprites = new ArrayList<PImage>();
ArrayList<PImage> explosionSprites = new ArrayList<PImage>();
ArrayList<PImage> planeSprites = new ArrayList<PImage>();
ArrayList<PImage> playerSprites = new ArrayList<PImage>();
PImage backgroundSprite;
PImage bombSprite;
PImage groundSprite;
//PImage scoreSprite;
//ArrayList<PImage> numberSprites = new ArrayList<PImage>();

Player player;
PlaneGenerator planeGenerator = new PlaneGenerator();
ObjectGenerator objectGenerator = new ObjectGenerator();

public boolean startingFrame = true;

public void setup() {
  size(1000, 600);
  frameRate(60);
  this.player = new Player("Player1");
  this.gameObjects.add(this.player);
  noSmooth();
  for (int i = 0; i < 6; i++) {
    this.treeSprites.add(loadImage("Graphics/Tree/Tree" + i + ".png"));
  }
  for (int i = 0; i < 2; i++) {
    this.tankSprites.add(loadImage("Graphics/Tank/Tank" + i + ".png"));
  }
  for (int i = 0; i < 8; i++) {
    explosionSprites.add(loadImage("Graphics/Explosion/Explosion" + i + ".png"));
  }
  for (int i = 0; i < 2; i++) {
    this.planeSprites.add(loadImage("Graphics/Messerschmitt/Messerschmitt" + i + ".png"));
  }
  for (int i = 0; i < 6; i++) {
    PImage frame = loadImage("Graphics/Spitfire/Spitfire" + i + ".png");
    this.playerSprites.add(frame);
  }
  //for (int i = 0; i < 10; i++) {
  //  PImage frame = loadImage("Graphics/Numbers/" + i + ".png");
  //  this.numberSprites.add(frame);
  //}
  this.backgroundSprite = loadImage("Graphics/Background.png");
  this.bombSprite = loadImage("Graphics/Bomb.png");
  this.groundSprite = loadImage("Graphics/Ground.png");
  //this.scoreSprite = loadImage("Graphics/Score.png");
}

public void draw() {
  if (!this.pauseToggle) {
    planeGenerator.update();
    objectGenerator.update();
    if (startingFrame) {
      this.createGround();
      this.createBackground();
    }
    
    int count = 0;
    int cycles = 0;
    ArrayList<GameObject> gameObjectsAdded = new ArrayList<GameObject>();
    while (count < this.gameObjects.size()) {
      for (GameObject gameObject : this.gameObjects) {
        if (!gameObjectsAdded.contains(gameObject)) {
          if (cycles == 0) {
            if (gameObject.containsTag("Background")) {
              gameObject.update();
              gameObjectsAdded.add(gameObject);
              count++;
            }
          } else if (cycles == 1) {
            if (gameObject.containsTag("Ground")) {
              gameObject.update();
              gameObjectsAdded.add(gameObject);
              count++;
            }
          } else {
            gameObject.update();
            gameObjectsAdded.add(gameObject);
            count++;
          }
        }
      }
      cycles++;
    }
    for (GameObject gameObject : this.toRemove) {
      gameObjects.remove(gameObject);
    }
    this.toRemove.clear();
    for (GameObject gameObject : this.toAdd) {
      gameObjects.add(gameObject);
    }
    this.toAdd.clear();
    
    //imageMode(CORNER);
    //image(scoreSprite, 10, 10, 282, 42);
  }
}

public void destroy(GameObject gameObject) {
  if (!this.toRemove.contains(gameObject)) {
    //println("Deleted: " + gameObject.getName());
    this.toRemove.add(gameObject);
  }
}

public void instantiate(GameObject gameObject) {
  if (!this.toAdd.contains(gameObject)) {
    //println("Instantiated: " + gameObject.getName());
    this.toAdd.add(gameObject);
  }
}

public void keyPressed() {
  if (keyCode == 87) { this.player.setUp(true); }
  if (keyCode == 83) { this.player.setDown(true); }
  if (keyCode == 65) { this.player.setLeft(true); }
  if (keyCode == 68) { this.player.setRight(true); }
  if (keyCode == 74) { this.createBomb(); }
  if (keyCode == 72) { 
    this.createPlaneShot(new PVector(this.player.getTransform().position.x, this.player.getTransform().position.y-7), true);
    this.createPlaneShot(new PVector(this.player.getTransform().position.x, this.player.getTransform().position.y+7), true);
  }
  if (keyCode == 82) { this.player = new Player("Player2"); this.gameObjects.add(player);}
  if (keyCode == 80) { this.pauseToggle = !this.pauseToggle; }
  if (keyCode == 70) { frameRate(20); }
}

public void keyReleased() {
  if (keyCode == 87) { this.player.setUp(false); }
  if (keyCode == 83) { this.player.setDown(false); }
  if (keyCode == 65) { this.player.setLeft(false); }
  if (keyCode == 68) { this.player.setRight(false); }
  if (keyCode == 70) { frameRate(60); }
}

public void createGround() {
  Ground newGround = new Ground("Ground");
    
  instantiate(newGround);
}

public void createBackground() {
  Background newBackground = new Background("Background");
    
  instantiate(newBackground);
}

public void createBomb() {
  Bomb newBomb = new Bomb("Bomb");
  
  instantiate(newBomb);
}

public void createExplosion(PVector position) {
  Explosion newExplosion = new Explosion("Explosion");
  newExplosion.getTransform().position = position;
  
  instantiate(newExplosion);
}

public void createEnemyPlane() {
  EnemyPlane newEnemyPlane = new EnemyPlane("EnemyPlane");
  
  instantiate(newEnemyPlane);
}

public void createTree() {
  Tree newTree = new Tree("Tree");
  
  instantiate(newTree);
}

public void createTank() {
  Tank newTank = new Tank("Tank");
  
  instantiate(newTank);
}

public void createTankShot(PVector position) {
  TankShot newTankShot = new TankShot("TankShot");
  newTankShot.getTransform().position = position;
  instantiate(newTankShot);
}

public void createPlaneShot(PVector position, boolean player) {
  PlaneShot newPlaneShot = new PlaneShot("TankShot", player);
  newPlaneShot.getTransform().position = position;
  instantiate(newPlaneShot);
}
