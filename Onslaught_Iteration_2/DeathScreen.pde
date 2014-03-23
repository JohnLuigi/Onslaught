
class DeathScreen
{
  DeathScreen()
  {
    
  }
  
  void draw()
  {
    //overlaying gameover screen to show movement still in the background
    if(gameOver)
    {
      deathCount++;
      
      if(deathCount == 1)
      {
        playerDeathSnd.trigger();
      }
      
      image(bloodSpatter, width/2, height/2);
      
      String startOverString = "Press Enter to start over";
      text(startOverString, width/2 - 140, height/2);
      
      float accuracy;
      
      if(shotsFired == 0)
      {
        accuracy = 0.0;
      }
      else 
      {
         accuracy = (float)hits / (float)shotsFired * 100.0;
      }
      
      String statsString = "Your accuracy was: " + accuracy + "%";
      text(statsString, width/2 - 140, height / 2 + 50);
    }
  }
}


