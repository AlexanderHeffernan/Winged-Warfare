import processing.sound.*;
public boolean soundLibrary = true;

// Define lists to store gameobjects to remove and add dynamically
public ArrayList<GameObject> gameObjects = new ArrayList<GameObject>();
public ArrayList<GameObject> toRemove = new ArrayList<GameObject>();
public ArrayList<GameObject> toAdd = new ArrayList<GameObject>();

// Game mode variables
public enum GameMode { ATTACK, SUPPLY };
public GameMode gameMode = GameMode.ATTACK;

// Score variables
public int totalScore = 0;
public int[] highScore = {0, 0};

// Pause/menu variables
public boolean pauseToggle = false;
public boolean menuDrawn = false;
public boolean playing = false;

// Loading variables
public boolean assetsLoaded = false;
public int loadedCount = 0;
public int loadCount = 32;
public String currentlyLoading = "";
public boolean assetsLoading = false;

public float worldSpeed = 4;

// Define constants for direction strings
public static final String LEFT = "left";
public static final String RIGHT = "right";
public static final String TOP = "top";
public static final String BOTTOM = "bottom";

// Arraylists to store various image assets
ArrayList<PImage> treeSprites = new ArrayList<PImage>();
ArrayList<PImage> tankSprites = new ArrayList<PImage>();
ArrayList<PImage> tentSprites = new ArrayList<PImage>();
ArrayList<PImage> alliedTentSprites = new ArrayList<PImage>();
ArrayList<PImage> explosionSprites = new ArrayList<PImage>();
ArrayList<PImage> planeSprites = new ArrayList<PImage>();
ArrayList<PImage> playerSprites = new ArrayList<PImage>();
ArrayList<PImage> supplyDropSprites = new ArrayList<PImage>();
ArrayList<PImage> controlsSprites = new ArrayList<PImage>();
ArrayList<PImage> gameModeSprites = new ArrayList<PImage>();
ArrayList<PImage> playButtonSprites = new ArrayList<PImage>();
ArrayList<PImage> exitButtonSprites = new ArrayList<PImage>();
ArrayList<PImage> restartButtonSprites = new ArrayList<PImage>();
ArrayList<PImage> resumeButtonSprites = new ArrayList<PImage>();
ArrayList<PImage> numberSprites = new ArrayList<PImage>();
ArrayList<PImage> soundButtonsSprites = new ArrayList<PImage>();

// Single image assets
PImage supplyDropIcon;
PImage backgroundSprite;
PImage backgroundParallax1Sprite;
PImage backgroundParallax2Sprite;
PImage backgroundParallax2OpeningSprite;
PImage bombSprite;
PImage groundSprite;
PImage scoreSprite;
PImage highSprite;

// Initialize gameobjects, generators, and controllers
SoundController sound = new SoundController();
Player player;
Controls controls;
AirObjectGenerator airObjectGenerator = new AirObjectGenerator();
ObjectGenerator objectGenerator = new ObjectGenerator();

// Flag to handle the frist frame of the game
public boolean startingFrame = true;

/**
 * This function is called once at the beginning of the program
 */
public void setup() {
  size(1000, 600);
  frameRate(60);
  noSmooth();
}

/**
 * This function controls the main game loop and
 * calls all other relevant class "update" functions.
 */
public void draw() {
  if (!this.assetsLoaded) {
    // Display loading screen
    rectMode(CENTER);
    fill(10,10,10, 255);
    rect(width/2, height/2, width, height);
    
    textSize(30);
    fill(255,255,255);
    text("Loading", width/2-45, height/2-25);
    textSize(18);
    fill(200,200,200);
    text(this.currentlyLoading, width/2-358, height/2+70);
    
    rectMode(CORNER);
    fill(0, 0, 0);
    stroke(255,255,255);
    rect(width/2 - ((this.loadCount/1.5)*32+32)/2, height/2-12, (this.loadCount/1.5)*32+32, 32 + 25);
    fill(255, 255, 255);
    rect(width/2 - ((this.loadCount/1.5)*32)/2, height/2, (this.loadedCount/1.5)*32, 32);
    stroke(0,0,0,0);
      
    if (this.assetsLoading) {
      this.loadAssets(this.loadedCount);
    } else {
      this.assetsLoading = true;
    }
  }
  // Game logic and rendering whenb assets are loaded
  else {
    sound.update();
    // If player is dead
    if (!this.gameObjects.contains(this.player)) {
      this.playing = false;
      this.restart();
      sound.hushBackgroundMusic();
    }
    // If not paused
    if (!this.pauseToggle) {
      this.menuDrawn = false;
      // Update generators
      airObjectGenerator.update();
      objectGenerator.update();
      
      // Cycle through all gameObjects
      int count = 0;
      int cycles = 0;
      ArrayList<GameObject> gameObjectsAdded = new ArrayList<GameObject>();
      while (count < this.gameObjects.size()) {
        for (GameObject gameObject : this.gameObjects) {
          if (!gameObjectsAdded.contains(gameObject)) {
            // Update gameobjects in correct order
            if (cycles == 0) {
              if (gameObject.containsTag("Background")) {
                gameObject.update();
                gameObjectsAdded.add(gameObject);
                count++;
                controls.update();
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
      // Remove all gameObjects toRemove
      for (GameObject gameObject : this.toRemove) {
        gameObjects.remove(gameObject);
      }
      this.toRemove.clear();
      // Add all gameObjects toAdd
      for (GameObject gameObject : this.toAdd) {
        gameObjects.add(gameObject);
      }
      this.toAdd.clear();
      
      // Display opaque grey rectangle over entire screen
      // to make game darker for ambience.
      fill(100,100,100,100);
      rectMode(CORNER);
      rect(0, 0, width, height);
      
      // Draw players score/highscore to screen
      imageMode(CORNER);
      image(scoreSprite, 10, 10, 282, 42);
      
      String[] digitsStrings = String.valueOf(totalScore).split("");
      for(int i = 0; i < digitsStrings.length; i++) {
        image(numberSprites.get(Integer.valueOf(digitsStrings[i])), 292 + 48*i, 10, 42, 42);
      }
      
      int highScoreIndex = gameMode == GameMode.ATTACK ? 0 : 1;
      
      if (totalScore > highScore[highScoreIndex]) {
        highScore[highScoreIndex] = totalScore;
        String[] lines = {String.valueOf(highScore[0]), String.valueOf(highScore[1])};
        saveStrings("highScore.txt", lines);
      }
      
      // Toggle starting frame if necessary
      if (this.startingFrame) {
        this.startingFrame = false;
        if (!playing)
          this.pauseToggle = true;
      }
        
    }
    // If game is paused and assets are loaded
    else {
      imageMode(CENTER);
      rectMode(CORNER);
        
      // If user is currently in the middle of a game
      if (playing) {
        // Draw resume button, and show if hovering
        if (width/2-171 <= mouseX && mouseX <= width/2+171 && height/3-39 <= mouseY && mouseY <= height/3+39)
          image(resumeButtonSprites.get(1), width/2, height/3, 342, 78);
        else
          image(resumeButtonSprites.get(0), width/2, height/3, 342, 78); 
          
        // Draw restart button, and show if hovering
        if (width/2-177 <= mouseX && mouseX <= width/2+177 && height/3+83-39 <= mouseY && mouseY <= height/3+83+39)
          image(restartButtonSprites.get(1), width/2, height/3+83, 354, 78);
        else 
          image(restartButtonSprites.get(0), width/2, height/3+83, 354, 78);
         
        // Draw exit button, and show if hovering
        if (width/2-108 <= mouseX && mouseX <= width/2+108 && height/3+166-39 <= mouseY && mouseY <= height/3+166+39)
          image(exitButtonSprites.get(1), width/2, height/3+166, 204, 78);
        else 
          image(exitButtonSprites.get(0), width/2, height/3+166, 204, 78);
      }
      // If user is not in the middle of a game
      else {
        // Draw play button, and show if hovering
        if (width/2-108 <= mouseX && mouseX <= width/2+108 && height/3-39 <= mouseY && mouseY <= height/3+39)
          image(playButtonSprites.get(1), width/2, height/3, 216, 78);
        else 
          image(playButtonSprites.get(0), width/2, height/3, 216, 78); 
        
        // Draw exit button, and show if hovering
        if (width/2-102 <= mouseX && mouseX <= width/2+102 && height/3+83-39 <= mouseY && mouseY <= height/3+83+39)
          image(exitButtonSprites.get(1), width/2, height/3+83, 204, 78);
        else 
          image(exitButtonSprites.get(0), width/2, height/3+83, 204, 78);
        
        // Draw gameMode button, and show if hovering
        if (width-108-120 <= mouseX && mouseX <= width-108+120 && height-120-132 <= mouseY && mouseY <= height-120+132) {
          if (gameMode == GameMode.ATTACK) 
            image(gameModeSprites.get(1), width-108, height-114, 240, 264);
          else
            image(gameModeSprites.get(3), width-108, height-114, 240, 264);
        } else {
          if (gameMode == GameMode.ATTACK) 
            image(gameModeSprites.get(0), width-108, height-114, 240, 264);
          else
            image(gameModeSprites.get(2), width-108, height-114, 240, 264);
        }
      }
      // Call sound controls to draw their part of the menu
      sound.drawToMenu();
       
      // If this is first frame of drawing menu,
      // draw menu's opaque background and highSprite.
      if (!this.menuDrawn) {
        fill(50,50,50,200);
        rectMode(CORNER);
        rect(0, 0, width, height);
        imageMode(CORNER);
        image(highSprite, 10, 60, 198, 42);
        this.menuDrawn = true;
      }
      // Draw highscore to screen.
      rectMode(CORNER);
      fill(60, 66, 70);
      rect(208, 60, 500, 42);
      int highScoreIndex = gameMode == GameMode.ATTACK ? 0 : 1;
      String[] digitsStrings = String.valueOf(highScore[highScoreIndex]).split("");
      imageMode(CORNER);
      for(int i = 0; i < digitsStrings.length; i++) {
        image(numberSprites.get(Integer.valueOf(digitsStrings[i])), 244 + 48*i, 60, 42, 42);
      }
    }
  }
}

/**
 * This function is used to load game assest incrementally,
 * and updates variables so loading screen can show progress
 * to user.
 */
public void loadAssets(int index) {
  // Switch case to load different assets step by step
  switch(index) {
    case 0:
      this.currentlyLoading = "Sounds/Bullet.wav";
      break;
    case 1:
      if (soundLibrary) { sound.setBulletSound(new SoundFile(this, "Sounds/Bullet.wav")); }
      this.currentlyLoading = "Sounds/explosion.wav";
      break;
    case 2:
      if (soundLibrary) { sound.setExplosionSound(new SoundFile(this, "Sounds/explosion.wav")); }
      this.currentlyLoading = "Sounds/Background-music.wav";
      break;
    case 3:
      if (soundLibrary) { sound.setBackgroundMusic(new SoundFile(this, "Sounds/Background-music.wav")); }
      sound.hushBackgroundMusic();
      sound.playBackgroundMusic();
      this.currentlyLoading = "Sounds/bombFalling.wav";
      break;
    case 4:
      if (soundLibrary) { sound.setBombFallingSound(new SoundFile(this, "Sounds/bombFalling.wav")); }
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
      for (int i = 0; i < 6; i++) {
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
      this.currentlyLoading = "Graphics/SupplyDrop/...";
      break;
    case 22:
      for (int i = 0; i < 3; i++) {
        PImage frame = loadImage("Graphics/SupplyDrop/frame" + i + ".png");
        this.supplyDropSprites.add(frame);
      }
      this.currentlyLoading = "Sounds/Graphics/Tent..";
      break;
    case 23:
      for (int i = 0; i < 2; i++) {
        PImage frame = loadImage("Graphics/Tent/frame" + i + ".png");
        this.tentSprites.add(frame);
      }
      this.currentlyLoading = "Sounds/supplyDrop.wav";
      break;
    case 24:
      if (soundLibrary) { sound.setSupplyDropSound(new SoundFile(this, "Sounds/supplyDrop.wav")); }
      this.currentlyLoading = "Graphics/Controls/...";
      break;
    case 25:
      for (int i = 0; i < 2; i++) {
        PImage frame = loadImage("Graphics/Controls/frame" + i + ".png");
        this.controlsSprites.add(frame);
      }
      this.currentlyLoading = "Graphics/BackgroundParallax-2-opening.png";
      break;
    case 26:
      this.backgroundParallax2OpeningSprite = loadImage("Graphics/BackgroundParallax-2-opening.png");
      this.currentlyLoading = "Graphics/GameMode/...";
      break;
    case 27:
      for (int i = 0; i < 4; i++) {
        PImage frame = loadImage("Graphics/GameMode/frame" + i + ".png");
        this.gameModeSprites.add(frame);
      }
      this.currentlyLoading = "Graphics/AlliedTent/...";
      break;
    case 28:
      for (int i = 0; i < 5; i++) {
        PImage frame = loadImage("Graphics/AlliedTent/frame" + i + ".png");
        this.alliedTentSprites.add(frame);
      }
      this.currentlyLoading = "Graphics/SupplyDropIcon.png";
      break;
    case 29:
      this.supplyDropIcon = loadImage("Graphics/SupplyDropIcon.png");
      this.currentlyLoading = "Graphics/SoundButtons/...";
      break;
    case 30:
      for (int i = 0; i < 8; i++) {
        PImage frame = loadImage("Graphics/SoundButtons/frame" + i + ".png");
        this.soundButtonsSprites.add(frame);
      }
      this.currentlyLoading = "Preparing game...";
      break;
    case 31:
      this.player = new Player("Player1");
      this.controls = new Controls();
      this.gameObjects.add(this.player);
      this.gameObjects.add(new Ground("Ground1"));
      this.gameObjects.add(new Background("BackGround1"));
      this.gameObjects.add(new BackgroundParallax1("BackgroundParallax1"));
      this.gameObjects.add(new BackgroundParallax2("BackgroundParallax2"));
      this.currentlyLoading = "Fetching high score...";
    case 32:
      String[] lines = loadStrings("highScore.txt");
      this.highScore[0] = Integer.valueOf(lines[0]);
      this.highScore[1] = Integer.valueOf(lines[1]);
      // Once loading is finished, flag it.
      this.assetsLoaded = true;
      this.currentlyLoading = "Done!";
  }
  this.assetsLoading = false;
  this.loadedCount++;
}

/**
 * This function is to restart the game,
 * preparing all controllers, generators, gameObjects, and
 * variables for a new game to be played.
 */
public void restart() {
  // Delete all current gameObjects.
  this.gameObjects.clear();
  
  // Toggle relevant flags.
  this.startingFrame = true;
  this.pauseToggle = false;
  
  // Prepare player
  this.player = new Player("Player1");
  this.controls = new Controls();
  
  // Prepare gameObjects for new scene.
  this.gameObjects.add(this.player);
  this.gameObjects.add(new Ground("Ground1"));
  this.gameObjects.add(new Background("BackGround1"));
  this.gameObjects.add(new BackgroundParallax1("BackgroundParallax1"));
  this.gameObjects.add(new BackgroundParallax2("BackgroundParallax2"));
  
  // Reset generators and controllers
  this.airObjectGenerator.reset();
  this.objectGenerator.reset();
  sound.resetBackgroundMusic();
}

/**
 * Function to remove a gameObject from the scene.
 */
public void destroy(GameObject gameObject) {
  if (!this.toRemove.contains(gameObject)) { this.toRemove.add(gameObject); }
}

/**
 * Function to add create a new gameObject.
 */
public void instantiate(GameObject gameObject) {
  if (!this.toAdd.contains(gameObject)) { this.toAdd.add(gameObject); }
}

/*
 * Handle user key presses.
 */
public void keyPressed() {
  if (assetsLoaded) {
    if (!pauseToggle) {
      if (keyCode == 87) { this.player.setUp(true); } // 'W' key
      if (keyCode == 83) { this.player.setDown(true); } // 'S' key
      if (keyCode == 65) { this.player.setLeft(true); } // 'A' key
      if (keyCode == 68) { this.player.setRight(true); } // 'D' key
      
      if (keyCode == 74) { // 'J' key
        // Ensure player can drop bomb/supply
        if (this.player.bombCount > 0 && this.player.canDropBomb && !this.player.crashing && !this.player.crashed) {
          this.player.bombCount--;
          if (gameMode == GameMode.ATTACK) { this.createBomb(); }
          else                             { this.createPlayerSupply(); }
          this.player.canDropBomb = false;
        }
      }
      
      if (gameMode == GameMode.ATTACK) {
        if (keyCode == 72) { // 'H' key
          // Ensure player can shoot
          if (this.player.canShootBullet && !this.player.crashing && !this.player.crashed) {
            // Calculate angle to shoot with
            int angle = 0;
            if (this.player.getTransform().velocity.y > 0) {
              angle = 8;
            } else if (this.player.getTransform().velocity.y < 0) {
              angle = -8;
            }
            this.createPlaneShot(new PVector(this.player.getTransform().position.x+30, this.player.getTransform().position.y+9), true, angle);
            this.player.canShootBullet = false;
          }
        }
      }
    }
    if (playing && !pauseToggle) {
      if (keyCode == 80) { // 'P' key
        if (this.pauseToggle) { 
          sound.loudenBackgroundMusic();
        }
        else { sound.hushBackgroundMusic(); }
        // End all players current key presses
        this.pauseToggle = !this.pauseToggle;
        this.player.setDown(false);
        this.player.setUp(false);
        this.player.setLeft(false);
        this.player.setRight(false);
      }
    }
  }
}

/**
 * Handle user key releases.
 */
public void keyReleased() {
  if (!pauseToggle && assetsLoaded) {
    if (keyCode == 72) {this.player.canShootBullet = true; } // 'H' key
    if (keyCode == 74) { this.player.canDropBomb = true; } // 'J' key
    if (keyCode == 87) { this.player.setUp(false); } // 'W' key
    if (keyCode == 83) { this.player.setDown(false); } // 'S' key
    if (keyCode == 65) { this.player.setLeft(false); } // 'A' key
    if (keyCode == 68) { this.player.setRight(false); } // 'D' key
  }
}

/**
 * Handle mouse clicks.
 */
public void mousePressed() {
  if (assetsLoaded) {
    if (this.pauseToggle) {
      if (playing) {
        // If resume button pressed
        if (width/2-171 <= mouseX && mouseX <= width/2+171 && height/3-39 <= mouseY && mouseY <= height/3+39) {
          this.pauseToggle = false;
          if (this.playing == false)
            this.totalScore = 0;
          this.playing = true;
          sound.loudenBackgroundMusic();
        }
        // If resetart button pressed
        if (width/2-177 <= mouseX && mouseX <= width/2+177 && height/3+83-39 <= mouseY && mouseY <= height/3+83+39) {
          restart();
          this.totalScore = 0;
          sound.loudenBackgroundMusic();
        }
        // If exit button pressed
        if (width/2-108 <= mouseX && mouseX <= width/2+108 && height/3+166-39 <= mouseY && mouseY <= height/3+166+39) {
          this.playing = false;
          this.restart();
          sound.hushBackgroundMusic();
        }
      } else {
        // If play button pressed
        if (width/2-108 <= mouseX && mouseX <= width/2+108 && height/3-39 <= mouseY && mouseY <= height/3+39) { 
          this.pauseToggle = false;
          if (this.playing == false)
            this.totalScore = 0;
          this.playing = true;
          sound.loudenBackgroundMusic();
        }
        // If exit button pressed
        if (width/2-102 <= mouseX && mouseX <= width/2+102 && height/3+83-39 <= mouseY && mouseY <= height/3+83+39) {
          exit();
        }
        // If game mode button pressed
        if (width-108-120 <= mouseX && mouseX <= width-108+120 && height-120-132 <= mouseY && mouseY <= height-120+132) {
          if (gameMode == GameMode.ATTACK) { gameMode = GameMode.SUPPLY; }
          else if (gameMode == GameMode.SUPPLY) { gameMode = GameMode.ATTACK; }
          this.totalScore = 0;
          restart();
        }
      }
      // If sound effects button pressed
      if (75-69 < mouseX && mouseX < 75+69 && height-72-66 < mouseY && mouseY < height-72+66) {
        sound.toggleEffects();
      }
      // If music button pressed
      if (219-69 < mouseX && mouseX < 219+69 && height-72-66 < mouseY && mouseY < height-72+66) {
        sound.toggleMusic();
      }
    }
  }
}

// GameObject creators

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

public void createPlayerSupply() {
  PlayerSupply newPlayerSupply = new PlayerSupply("PlayerSupply");
  
  instantiate(newPlayerSupply);
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


public void createSupplyDrop() {
  SupplyDrop newSupplyDrop = new SupplyDrop("SupplyDrop");
  
  instantiate(newSupplyDrop);
}

public void createTree() {
  Tree newTree = new Tree("Tree");
  
  instantiate(newTree);
}

public void createTank() {
  Tank newTank = new Tank("Tank");
  
  instantiate(newTank);
}

public void createTent() {
  Tent newTent = new Tent("Tent");
  
  instantiate(newTent);
}

public void createAlliedTent() {
  AlliedTent newAlliedTent = new AlliedTent("Tent");
  
  instantiate(newAlliedTent);
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
