class Bullet
{
  int xPos;
  int yPos;
  
  int speed;
  
  int w;
  int h;
  
  boolean movingRight;
  boolean canHit;
  
  Bullet(int xPos_, int yPos_, Player player)
  {
    xPos = xPos_;
    yPos = yPos_;
    
    speed = 15;
    
    w = 20;
    h = 10;
    
    canHit = true;
    movingRight = player.facingRight;
  }
  
  void move()
  {
    if(movingRight)
    {
      xPos += speed;
    }
    else
    {
      xPos -= speed;
    }
    
  }
  
  boolean checkEnemyHit(Enemy enemyIn)
  {
    if(canHit && (xPos >= enemyIn.xPos - enemyIn.w / 2 && xPos <= enemyIn.xPos + enemyIn.w / 2) && (yPos >= enemyIn.yPos - enemyIn.h / 2 && yPos <= enemyIn.yPos + enemyIn.h / 2) )
    {
      // set canHit to false so that the bullet only hits the enemy once
      // instead of counting each frame that a bullet and enemy overlap as a hit
      canHit = false;
      return true;
    }
    else
    {
      return false;
    }
  }
  
  void draw()
  {
    pushMatrix();
    
    if (movingRight == false)
    {
      translate(xPos - 84, yPos - 18);
      scale(-1, 1);
    }
    else
    {
      translate(xPos - 18, yPos - 18);
    }
    
    image(bulletImg, 0, 0);    
    popMatrix();    
  }  
}
