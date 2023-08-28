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
