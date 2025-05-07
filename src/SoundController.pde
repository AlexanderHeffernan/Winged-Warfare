class SoundController {
  // Flags
  private boolean music;
  private boolean loud;
  private boolean effects;
  private int timer = 0;
  
  // Constant variables
  private static final float MAX_MUSIC_VOLUME = 1;
  private static final float MIN_MUSIC_VOLUME = 0.2;
  
  // Sound files
  private SoundFile backgroundMusic;
  private SoundFile bulletSound;
  private SoundFile explosionSound;
  private SoundFile bombFallingSound;
  private SoundFile supplyDropSound;
  
  // Constructor
  public SoundController() {
    this.music = true;
    this.effects = true;
    this.loud = false;
  }
  
  public void update() {
    if (timer >= 1800) { 
      resetBackgroundMusic(); 
      timer = 0;
    }
    else { timer++; }
  }
    
  
  // Draw sound settings to the menu
  public void drawToMenu() {
    imageMode(CENTER);
    // Draw music toggle button, showing whether or not toggled,
    // and whether or not hovering
    if (music) {
      if (219-69 < mouseX && mouseX < 219+69 && height-72-66 < mouseY && mouseY < height-72+66)
        image(soundButtonsSprites.get(5), 219, height - 72, 138, 132);
      else
        image(soundButtonsSprites.get(4), 219, height - 72, 138, 132);
    } else {
      if (219-69 < mouseX && mouseX < 219+69 && height-72-66 < mouseY && mouseY < height-72+66)
        image(soundButtonsSprites.get(7), 219, height - 72, 138, 132);
      else
        image(soundButtonsSprites.get(6), 219, height - 72, 138, 132);
    }
    
    // Draw effects toggle button, showing whether or not toggled,
    // and whether or not hovering
    if (effects) {
      if (75-69 < mouseX && mouseX < 75+69 && height-72-66 < mouseY && mouseY < height-72+66)
        image(soundButtonsSprites.get(1), 75, height - 72, 138, 132);
      else
        image(soundButtonsSprites.get(0), 75, height - 72, 138, 132);
    } else {
      if (75-69 < mouseX && mouseX < 75+69 && height-72-66 < mouseY && mouseY < height-72+66)
        image(soundButtonsSprites.get(3), 75, height - 72, 138, 132);
      else
        image(soundButtonsSprites.get(2), 75, height - 72, 138, 132);
    }
  }
  
  /**
   * Toggle music on/off
   */
  public void toggleMusic() { 
    music = !music;
    if (music) {
      if (loud) { loudenBackgroundMusic(); }
      else { hushBackgroundMusic(); }
    } else {
      if (soundLibrary) { backgroundMusic.amp(0); }
    }
    drawToMenu();
  }
  
  /**
   * Toggle sound effects on/off
   */
  public void toggleEffects() {
    effects = !effects;
    drawToMenu();
  }
  
  /**
   * Increase background music volume to constant variable.
   */
  public void loudenBackgroundMusic() {
    if (music && soundLibrary) { backgroundMusic.amp(MAX_MUSIC_VOLUME); }
   loud = true;
  }
  
  /**
   * Decrease background music volume to constant variable.
   */
  public void hushBackgroundMusic() {
    if (music && soundLibrary) { backgroundMusic.amp(MIN_MUSIC_VOLUME); }
    loud = false;
  }
  
  // Sound playing functions
  
  public void playBackgroundMusic() { if (soundLibrary) { backgroundMusic.play(); } timer = 0; }
  
  public void playBulletSound() { 
    if (effects && soundLibrary) { bulletSound.play(); }
  }
  public void playExplosionSound() { 
    if (effects && soundLibrary) { explosionSound.play(); }
  }
  public void playBombFallingSound() { 
    if (effects && soundLibrary) { bombFallingSound.play(); }
  }
  public void playSupplyDropSound() { 
    if (effects && soundLibrary) { supplyDropSound.play(); }
  }
  
  // Sound file setting functions
  
  public void setBackgroundMusic(SoundFile sound) { backgroundMusic = sound; }
  public void setBulletSound(SoundFile sound) { bulletSound = sound; }
  public void setExplosionSound(SoundFile sound) { explosionSound = sound; }
  public void setBombFallingSound(SoundFile sound) {bombFallingSound = sound; }
  public void setSupplyDropSound(SoundFile sound) { supplyDropSound = sound; }
  
  /**
   * Reset the background music to play from the beginning.
   */
  public void resetBackgroundMusic() {
    if (soundLibrary) { 
      backgroundMusic.stop();
      backgroundMusic.play();
    }
    timer = 0;
  }
}
