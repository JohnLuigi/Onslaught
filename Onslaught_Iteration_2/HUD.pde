class HUD
{
  HUD()
  {
  }
  
  void draw()
  {
    textFont(f, 32);
    fill(255);
    
    String healthString = "Health: " + player.health;
    text(healthString, 50, 50);
    
    String scoreString = "Kills: " + score;
    text(scoreString, width - 200, 50);
  }
}
