class Enemy
{
  int xPos;
  int yPos;
  
  float xSeed;
  float ySeed;
  
  //enemy width and height
  int w;
  int h;
  
  //to use in determining how much the enemy will jutter around
  int variation;
  int speed;
  
  /*
  Enemy()
  {
    xPos = 400;
    yPos = 300;
    
    w = 50;
    h = 100;
    
    variation = 2;
    speed = 3;
    
    xSeed = random(100);
    ySeed = random(100);
  }
  */
  Enemy(int diff)
  {
    if(diff == 1)
    {
      
      xPos = (int)random(w, width - w);
      yPos = (int)random(h, height - h);
      
      w = 50;
      h = 100;
      
      variation = 2;
      speed = 3;
      xSeed = random(100);
    ySeed = random(100);
    }
    
    else if(diff == 2)
    {
      xPos = (int)random(w, width - w);
      yPos = (int)random(h, height - h);
      
      w = 50;
      h = 100;
      
      variation = 2;
      speed = 5;
      xSeed = random(100);
      ySeed = random(100);
      
    }
  }
  
  void move()
  {
    // will try to see if there is a way to direct the noise movement to the player
    xPos = (int)map(noise(xSeed), 0, 1, -200, width + 200);
    yPos = (int)map(noise(ySeed), 0, 1, -200, height + 200);
    
    xSeed += 0.005;
    ySeed += 0.005;
    
  }
  
  void draw()
  {
    image(enemyImg, xPos, yPos);
  }
  
}
