class Player  //name
{
  //attributes
  //player's xposition (heh)
  int xPos;
  //player's yposition
  int yPos;
  
  //x and Y velocities
  int velX;
  int velY;
  
  int animDelay;
  int animFrame;
  boolean facingRight;
  int runAnimDelay = 3; // # of cycles that pass between animation updates
  
  int runSpeed;
  int jumpSpeed;
  int jumpHeight;
  
  float fallSpeed;
  float gravity;
  float airFriction;
  
  boolean runningLeft;
  boolean runningRight;
  boolean jumping;
  boolean falling;
  boolean isOnGround;
  boolean isShooting;
  
  int health;
  
  //player width and height
  int w;
  int h;
  
  // vectors for checking the top, bottom, upper left, upper right,
  // lower left, and lower right of the player
  PVector top;
  PVector bottom;
  PVector upLeft;
  PVector botLeft;
  PVector upRight;
  PVector botRight;
  
  
  //constructor
  Player()
  {
    xPos = 100;
    yPos = 200;
    
    runSpeed = 10;
    jumpSpeed = 20;
    jumpHeight = 100;
    
    fallSpeed = 0;
    gravity = 0.8;
    airFriction = 1;
    
    runningLeft = false;
    runningRight = false;
    jumping = false;
    falling = true;
    isOnGround = false;
    isShooting = false;
    
    animDelay = 0;
    animFrame = 0;
    facingRight = true;
    
    health = 50;
    
    w = 25;
    h = 70;
    
    //the points used to check if the player is colliding with objects
    top = new PVector(xPos, yPos - h/2);
    bottom = new PVector(xPos, yPos + h/2);
    upLeft = new PVector(xPos - w/2, yPos - h/4);
    botLeft = new PVector(xPos - w/2, yPos + h/4);
    upRight = new PVector(xPos + w/2, yPos - h/4);
    botRight = new PVector(xPos + w/2, yPos + h/4);
    
  }
  
  
  // methods
  // since this is run every frame, all movement based changes are made here
  void checkMovement()
  {
    if (runningLeft)
    {
      xPos -= runSpeed;
    }
    
    if (runningRight)
    {
      xPos += runSpeed;
    }
    
    if (jumping)
    {
      yPos -= jumpSpeed;
    }
    
    // "gravity" implemented here
    if(isOnGround == false && falling == true)
    {
      yPos -= airFriction;
      yPos += fallSpeed;
      fallSpeed += gravity;
    }
    
    // stops the player from moving too far above the screen or below the ground
    yPos = constrain(yPos, jumpHeight, 425);
    xPos = constrain(xPos, 0 + w/2, width - w/2);
    
    if(yPos == 425)
    {
      fallSpeed = 0;
      jumping = false;
      isOnGround = true;
    }
    
    if(yPos == jumpHeight)
    {
      jumping = false;
      falling = true;
    }
    
    top = new PVector(xPos, yPos - h/2);
    bottom = new PVector(xPos, yPos + h/2);
    upLeft = new PVector(xPos - w/2, yPos - h/4);
    botLeft = new PVector(xPos - w/2, yPos + h/4);
    upRight = new PVector(xPos + w/2, yPos - h/4);
    botRight = new PVector(xPos + w/2, yPos + h/4);
      
  }
  
  // checks if any of the player's collision points are overlapping an enemy
  // returns true if they are overlapping
  boolean checkEnemyCollision(Enemy enemyIn)
  {
    //checks top PVector
    if((top.x >= enemyIn.xPos - enemyIn.w / 2 && top.x <= enemyIn.xPos + enemyIn.w / 2) 
    && (top.y >= enemyIn.yPos - enemyIn.h / 2 && top.y <= enemyIn.yPos + enemyIn.h / 2) )
    { return true; }
    
    //checks bottom PVector
    if((bottom.x >= enemyIn.xPos - enemyIn.w / 2 && bottom.x <= enemyIn.xPos + enemyIn.w / 2)
    && (bottom.y >= enemyIn.yPos - enemyIn.h / 2 && bottom.y <= enemyIn.yPos + enemyIn.h / 2) )
    { return true; }
    
    //checks upLeft PVector
    if((upLeft.x >= enemyIn.xPos - enemyIn.w / 2 && upLeft.x <= enemyIn.xPos + enemyIn.w / 2)
    && (upLeft.y >= enemyIn.yPos - enemyIn.h / 2 && upLeft.y <= enemyIn.yPos + enemyIn.h / 2) )
    { return true; }
    
    //checks botLeft PVector
    if((botLeft.x >= enemyIn.xPos - enemyIn.w / 2 && botLeft.x <= enemyIn.xPos + enemyIn.w / 2)
    && (botLeft.y >= enemyIn.yPos - enemyIn.h / 2 && botLeft.y <= enemyIn.yPos + enemyIn.h / 2) )
    { return true; }
    
    //checks upRight PVector
    if((upRight.x >= enemyIn.xPos - enemyIn.w / 2 && upRight.x <= enemyIn.xPos + enemyIn.w / 2)
    && (upRight.y >= enemyIn.yPos - enemyIn.h / 2 && upRight.y <= enemyIn.yPos + enemyIn.h / 2) )
    { return true; }
    
    //checks botRight PVector
    if((botRight.x >= enemyIn.xPos - enemyIn.w / 2 && botRight.x <= enemyIn.xPos + enemyIn.w / 2)
    && (botRight.y >= enemyIn.yPos - enemyIn.h / 2 && botRight.y <= enemyIn.yPos + enemyIn.h / 2) )
    { return true; }
    
    else 
    { return false; }
    
  }
  
  // I looked up an example of a platformer and they did this nifty Matrix/transforming stuff
  // pretty neat how it lets you do the transforms in one step
  
  void draw()
  {
    int playerWidth = playerStand.width;
    int playerHeight = playerStand.height;
    
    pushMatrix();
    
    translate(xPos, yPos);
    
    if(facingRight == false || runningLeft == true)
    {
      scale(-1, 1);
    }
    
    //translate(-playerWidth/2, -playerHeight/2);
    
    
    
    if(isOnGround == false && jumping == true)
    {
      image(playerRun2, 0 , 0);
    }
    
    else if(isShooting == true)
    {
      image(playerShoot, 0 ,0);
    }
    
    else if(runningLeft == false && runningRight == false)
    {
      image(playerStand, 0, 0);
    }
    
    
    
    else
    {
      if(animDelay--<0)
      {
        animDelay = runAnimDelay;
        if(animFrame == 0)
        {
          animFrame = 1;
        } else
        {
          animFrame = 0;
        }
      }
      
      if(animFrame == 0)
      {
        image(playerRun1, 0, 0);
      }
      else
      {
        image(playerRun2, 0, 0);
      }
      
      
    }
    
    popMatrix();
    
  }
  
  
  
  
}





















