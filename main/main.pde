import processing.sound.*;
public SoundFile backgroundMusic;
public SoundFile bulletSound;
public SoundFile explosionSound;
public SoundFile bombFallingSound;

public ArrayList<GameObject> gameObjects = new ArrayList<GameObject>();
public ArrayList<GameObject> toRemove = new ArrayList<GameObject>();
public ArrayList<GameObject> toAdd = new ArrayList<GameObject>();

public float worldSpeed = 4;
public int totalScore = 0;
public int highScore = 0;
public boolean pauseToggle = false;
public boolean menuDrawn = false;
public boolean playing = false;
public boolean assetsLoaded = false;
public int loadedCount = 0;
public int loadCount = 23;
public String currentlyLoading = "";
public boolean assetsLoading = false;

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
PImage backgroundParallax1Sprite;
PImage backgroundParallax2Sprite;
PImage bombSprite;
PImage groundSprite;
PImage scoreSprite;
PImage highSprite;
ArrayList<PImage> playButtonSprites = new ArrayList<PImage>();
ArrayList<PImage> exitButtonSprites = new ArrayList<PImage>();
ArrayList<PImage> restartButtonSprites = new ArrayList<PImage>();
ArrayList<PImage> resumeButtonSprites = new ArrayList<PImage>();
ArrayList<PImage> numberSprites = new ArrayList<PImage>();

Player player;
PlaneGenerator planeGenerator = new PlaneGenerator();
ObjectGenerator objectGenerator = new ObjectGenerator();

public boolean startingFrame = true;

public void setup() {
  size(1000, 600);
  frameRate(60);
  noSmooth();
}

public void draw() {
  if (!this.assetsLoaded) {
    rectMode(CENTER);
    fill(10,10,10, 255);
    rect(width/2, height/2, width, height);
    
    textSize(30);
    fill(255,255,255);
    text("Loading", width/2-45, height/2-25);
    textSize(18);
    fill(200,200,200);
    text(this.currentlyLoading, width/2-288, height/2+60);
    
    rectMode(CORNER);
    fill(0, 0, 0);
    stroke(255,255,255);
    rect(width/2 - (this.loadCount*24+24)/2, height/2-12, this.loadCount*24+24, 24+24);
    fill(255, 255, 255);
    rect(width/2 - (this.loadCount*24)/2, height/2, this.loadedCount*24, 24);
    stroke(0,0,0,0);
      
    if (this.assetsLoading) {
      this.loadAssets(this.loadedCount);
    } else {
      this.assetsLoading = true;
    }
  } else {
    if (!this.gameObjects.contains(this.player)) {
      this.playing = false;
      this.restart();
      this.backgroundMusic.stop();
    }
    if (!this.pauseToggle) {
      this.menuDrawn = false;
      planeGenerator.update();
      objectGenerator.update();
      
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
              if (gameObject.containsTag("BackgroundParallax2")) {
                gameObject.update();
                gameObjectsAdded.add(gameObject);
                count++;
              }
            } else if (cycles == 2) {
              if (gameObject.containsTag("BackgroundParallax1")) {
                gameObject.update();
                gameObjectsAdded.add(gameObject);
                count++;
              }
            } else if (cycles == 3) {
              if (gameObject.containsTag("Ground")) {
                gameObject.update();
                gameObjectsAdded.add(gameObject);
                count++;
              }
            } else if (cycles == 4) {
              if (gameObject.containsTag("Bomb")) {
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
      
      fill(100,100,100,100);
      rectMode(CORNER);
      rect(0, 0, width, height);
      
      imageMode(CORNER);
      image(scoreSprite, 10, 10, 282, 42);
      
      String[] digitsStrings = String.valueOf(totalScore).split("");
      for(int i = 0; i < digitsStrings.length; i++) {
        image(numberSprites.get(Integer.valueOf(digitsStrings[i])), 292 + 48*i, 10, 42, 42);
      }
      
      if (totalScore > highScore) {
        highScore = totalScore;
        String[] lines = {String.valueOf(highScore)};
        saveStrings("highScore.txt", lines);
      }
      
      if (this.startingFrame) {
        this.startingFrame = false;
        if (!playing)
          this.pauseToggle = true;
      }
        
    } else {
      imageMode(CENTER);
      if (width/2-108 <= mouseX && mouseX <= width/2+108 && height/3-39 <= mouseY && mouseY <= height/3+39) {
        if (playing) {
          image(resumeButtonSprites.get(1), width/2, height/3, 342, 78);
        } else {
          image(playButtonSprites.get(1), width/2, height/3, 216, 78);
        }
      } else {
        if (playing) {
          image(resumeButtonSprites.get(0), width/2, height/3, 342, 78);
        } else {
          image(playButtonSprites.get(0), width/2, height/3, 216, 78);
        }
      }
        
      if (playing) {
        if (width/2-108 <= mouseX && mouseX <= width/2+108 && height/3+83-39 <= mouseY && mouseY <= height/3+83+39)
          image(restartButtonSprites.get(1), width/2, height/3+83, 354, 78);
        else 
          image(restartButtonSprites.get(0), width/2, height/3+83, 354, 78);
        if (width/2-108 <= mouseX && mouseX <= width/2+108 && height/3+166-39 <= mouseY && mouseY <= height/3+166+39)
          image(exitButtonSprites.get(1), width/2, height/3+166, 204, 78);
        else 
          image(exitButtonSprites.get(0), width/2, height/3+166, 204, 78);
      } else {
        if (width/2-108 <= mouseX && mouseX <= width/2+108 && height/3+83-39 <= mouseY && mouseY <= height/3+83+39)
          image(exitButtonSprites.get(1), width/2, height/3+83, 204, 78);
        else 
          image(exitButtonSprites.get(0), width/2, height/3+83, 204, 78);
      }
        
      if (!this.menuDrawn) {
        fill(50,50,50,200);
        rectMode(CORNER);
        rect(0, 0, width, height);
        imageMode(CORNER);
        image(highSprite, 10, 60, 198, 42);
        
        String[] digitsStrings = String.valueOf(highScore).split("");
        for(int i = 0; i < digitsStrings.length; i++) {
          image(numberSprites.get(Integer.valueOf(digitsStrings[i])), 244 + 48*i, 60, 42, 42);
        }
        this.menuDrawn = true;
      }
    }
  }
}

public void loadAssets(int index) {
  switch(index) {
    case 0:
      this.currentlyLoading = "Sounds/Bullet.mp3";
      break;
    case 1:
      this.bulletSound = new SoundFile(this, "Sounds/Bullet.mp3");
      this.bulletSound.amp(0.7);
      this.currentlyLoading = "Sounds/explosion.mp3";
      break;
    case 2:
      this.explosionSound = new SoundFile(this, "Sounds/explosion.mp3");
      this.explosionSound.amp(0.2);
      this.currentlyLoading = "Sounds/Background-music.mp3";
      break;
    case 3:
      this.backgroundMusic = new SoundFile(this, "Sounds/Background-music.mp3");
      this.backgroundMusic.amp(0.5);
      this.currentlyLoading = "Sounds/bombFalling.mp3";
      break;
    case 4:
      this.bombFallingSound = new SoundFile(this, "Sounds/bombFalling.mp3");
      this.bombFallingSound.amp(0.5);
      this.currentlyLoading = "Graphics/Tree/...";
      break;
    case 5:
      for (int i = 0; i < 6; i++) {
        this.treeSprites.add(loadImage("Graphics/Tree/Tree" + i + ".png"));
      }
      this.currentlyLoading = "Graphics/Tank/...";
      break;
    case 6:
      for (int i = 0; i < 2; i++) {
        this.tankSprites.add(loadImage("Graphics/Tank/Tank" + i + ".png"));
      }
      this.currentlyLoading = "Graphics/Explosion/...";
      break;
    case 7:
      for (int i = 0; i < 8; i++) {
        explosionSprites.add(loadImage("Graphics/Explosion/Explosion" + i + ".png"));
      }
      this.currentlyLoading = "Graphics/Messershmitt/...";
      break;
    case 8:
      for (int i = 0; i < 2; i++) {
        this.planeSprites.add(loadImage("Graphics/Messerschmitt/Messerschmitt" + i + ".png"));
      }
      this.currentlyLoading = "Graphics/Spitfire/...";
      break;
    case 9:
      for (int i = 0; i < 6; i++) {
        PImage frame = loadImage("Graphics/Spitfire/Spitfire" + i + ".png");
        this.playerSprites.add(frame);
      }
      this.currentlyLoading = "Graphics/Numbers...";
      break;
    case 10:
      for (int i = 0; i < 10; i++) {
        PImage frame = loadImage("Graphics/Numbers/" + i + ".png");
        this.numberSprites.add(frame);
      }
      this.currentlyLoading = "Graphics/PlayButton/...";
      break;
    case 11:
      for (int i = 0; i < 2; i++) {
        PImage frame = loadImage("Graphics/PlayButton/Play" + i + ".png");
        this.playButtonSprites.add(frame);
      }
      this.currentlyLoading = "Graphics/ExitButton/...";
      break;
    case 12:
      for (int i = 0; i < 2; i++) {
        PImage frame = loadImage("Graphics/ExitButton/Exit" + i + ".png");
        this.exitButtonSprites.add(frame);
      }
      this.currentlyLoading = "Graphics/RestartButton/...";
      break;
    case 13:
      for (int i = 0; i < 2; i++) {
        PImage frame = loadImage("Graphics/RestartButton/Restart" + i + ".png");
        this.restartButtonSprites.add(frame);
      }
      this.currentlyLoading = "Graphics/ResumeButton/...";
      break;
    case 14:
      for (int i = 0; i < 2; i++) {
        PImage frame = loadImage("Graphics/ResumeButton/Resume" + i + ".png");
        this.resumeButtonSprites.add(frame);
      }
      this.currentlyLoading = "Graphics/Background.png";
      break;
    case 15:
      this.backgroundSprite = loadImage("Graphics/Background.png");
      this.currentlyLoading = "Graphics/BackgroundParallax-1.png";
      break;
    case 16:
      this.backgroundParallax1Sprite = loadImage("Graphics/BackgroundParallax-1.png");
      this.currentlyLoading = "Graphics/BackgroundParallax-2.png";
      break;
    case 17:
      this.backgroundParallax2Sprite = loadImage("Graphics/BackgroundParallax-2.png");
      this.currentlyLoading = "Graphics/Bomb.png";
      break;
    case 18:
      this.bombSprite = loadImage("Graphics/Bomb.png");
      this.currentlyLoading = "Graphics/Ground.png";
      break;
    case 19:
      this.groundSprite = loadImage("Graphics/Ground.png");
      this.currentlyLoading = "Graphics/Score.png";
      break;
    case 20:
      this.scoreSprite = loadImage("Graphics/Score.png");
      this.currentlyLoading = "Graphics/High.png";
      break;
    case 21:
      this.highSprite = loadImage("Graphics/High.png");
      this.currentlyLoading = "Preparing game...";
      break;
    case 22:
      this.player = new Player("Player1");
      this.gameObjects.add(this.player);
      this.gameObjects.add(new Ground("Ground1"));
      this.gameObjects.add(new Background("BackGround1"));
      this.gameObjects.add(new BackgroundParallax1("BackgroundParallax1"));
      this.gameObjects.add(new BackgroundParallax2("BackgroundParallax2"));
      this.currentlyLoading = "Fetching high score...";
    case 23:
      String[] lines = loadStrings("highScore.txt");
      this.highScore = Integer.valueOf(lines[0]);
      this.assetsLoaded = true;
      this.currentlyLoading = "Done!";
  }
  this.assetsLoading = false;
  this.loadedCount++;
}

public void restart() {
  this.gameObjects.clear();
  this.startingFrame = true;
  this.pauseToggle = false;
  this.player = new Player("Player1");
  this.gameObjects.add(this.player);
  this.gameObjects.add(new Ground("Ground1"));
  this.gameObjects.add(new Background("BackGround1"));
  this.gameObjects.add(new BackgroundParallax1("BackgroundParallax1"));
  this.gameObjects.add(new BackgroundParallax2("BackgroundParallax2"));
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
  if (!pauseToggle && assetsLoaded) {
    if (keyCode == 87) { this.player.setUp(true); }
    if (keyCode == 83) { this.player.setDown(true); }
    if (keyCode == 65) { this.player.setLeft(true); }
    if (keyCode == 68) { this.player.setRight(true); }
    if (keyCode == 74) { this.createBomb(); }
    if (keyCode == 72) { 
      int angle = 0;
      if (this.player.getTransform().velocity.y > 0) {
        angle = 8;
      } else if (this.player.getTransform().velocity.y < 0) {
        angle = -8;
      }
      this.createPlaneShot(new PVector(this.player.getTransform().position.x, this.player.getTransform().position.y), true, angle);
    }
    if (keyCode == 82) { this.player = new Player("Player2"); this.gameObjects.add(player);}
    if (keyCode == 70) { frameRate(20); }
  }
  if (assetsLoaded) {
    if (keyCode == 80) { this.pauseToggle = !this.pauseToggle; this.backgroundMusic.pause(); }
  }
}

public void keyReleased() {
  if (!pauseToggle && assetsLoaded) {
    if (keyCode == 87) { this.player.setUp(false); }
    if (keyCode == 83) { this.player.setDown(false); }
    if (keyCode == 65) { this.player.setLeft(false); }
    if (keyCode == 68) { this.player.setRight(false); }
    if (keyCode == 70) { frameRate(60); }
  }
}

public void mousePressed() {
  if (assetsLoaded) {
    if (this.pauseToggle) {
      if (width/2-108 <= mouseX && mouseX <= width/2+108 && height/3-39 <= mouseY && mouseY <= height/3+39) {
        this.pauseToggle = false;
        if (this.playing == false)
          this.totalScore = 0;
        this.playing = true;
        this.backgroundMusic.play();
      } else if (width/2-108 <= mouseX && mouseX <= width/2+108 && height/3+83-39 <= mouseY && mouseY <= height/3+83+39) {
        if (playing) {
          restart();
          this.totalScore = 0;
          this.backgroundMusic.stop();
          this.backgroundMusic.play();
        }
        else
          exit();
      } else if (width/2-108 <= mouseX && mouseX <= width/2+108 && height/3+166-39 <= mouseY && mouseY <= height/3+166+39 && playing) {
        exit();
      }
    }
  }
}

public void createGround() {
  Ground newGround = new Ground("Ground");
    
  instantiate(newGround);
}

public void createBackground() {
  Background newBackground = new Background("Background");
    
  instantiate(newBackground);
}

public void createBackgroundParallax1() {
  BackgroundParallax1 newBackgroundParallax1 = new BackgroundParallax1("BackgroundParallax1");
    
  instantiate(newBackgroundParallax1);
}

public void createBackgroundParallax2() {
  BackgroundParallax2 newBackgroundParallax2 = new BackgroundParallax2("BackgroundParallax2");
    
  instantiate(newBackgroundParallax2);
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

public void createEnemyPlane(PVector position) {
  EnemyPlane newEnemyPlane = new EnemyPlane("EnemyPlane", position);
  
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

public void createPlaneShot(PVector position, boolean player, int angle) {
  PlaneShot newPlaneShot = new PlaneShot("TankShot", player, angle);
  newPlaneShot.getTransform().position = position;
  instantiate(newPlaneShot);
}
