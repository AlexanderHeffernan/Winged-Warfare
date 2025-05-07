/**
 * The GameObject interface represents objects in the game
 * that can be updated and interacted with.
 */
public interface GameObject {
  String getName();
  int getScore();
  int getDamage();
  void takeDamage(int damage);
  ArrayList<String> getTags();
  Transform getTransform();
  
  void update();
  boolean containsTag(String tag);
}
