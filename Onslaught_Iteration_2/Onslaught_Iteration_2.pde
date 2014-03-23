/**
  Onslaught
  Written by: Eric Rackear
  
  Controls:
  Up Arrow = jump
  Left Arrow = move left
  Right Arrow = move right
  Spacebar = shoot
  
  This is a simple game that will eventually allow the player to move around and shoot
  progressively tougher and faster enemies while allowing you to upgrade your weapons
  to deal with the increasing threat. 
  
  In its current state, the player onl has one gun, and the collision detection is still
  wonky, so that is the main focus, then I will have more enemies and more features in general.
  
  To see the crazy number of bullets, hold down up to constantly jump
  and hold spacebar at the same time. For some reason, the character can't
  shoot continuously when moving sideways.
  
*/
import ddf.minim.*;
Minim minim;

Player player;
ArrayList<Enemy> enemyArray;
ArrayList<Bullet> bulletArray;
DeathScreen theScreen;
HUD theHUD;

int shotsFired = 0;
int maxBullets = 100;
int score = 0;
int hits = 0;

int difficulty;
int maxEnemies;
boolean canSpawn;
int respawnDelay;
int respawnTime;

boolean gameOver;
int deathCount;

//PImage characterImg;
PImage enemyImg;
PImage bulletImg;
PImage playerStand;
PImage playerRun1;
PImage playerRun2;
PImage playerShoot;
PImage rockyBackground;
PImage dungeonFloor;
PImage bloodSpatter;

AudioSample jumpSnd;
AudioSample shootSnd;
AudioSample enemyDeathSnd;
AudioSample playerDeathSnd;

PFont f;

void setup()
{
  size(800, 600);
  player = new Player();
  enemyArray = new ArrayList<Enemy>();
  bulletArray = new ArrayList<Bullet>();
  theScreen = new DeathScreen();
  theHUD = new HUD();
  
  difficulty = 1;
  maxEnemies = 4;
  canSpawn = true;
  respawnTime = 45;       // 1.5 seconds aka 45 frames
  respawnDelay = respawnTime;
  
  gameOver = false;
  deathCount = 0;
  
  //characterImg = loadImage("Character.png");
  enemyImg = loadImage("Enemy.png"); 
  bulletImg = loadImage("Bullet.png");
  playerStand = loadImage("Characterv2.png");
  playerRun1 = loadImage("Characterv2Run2.png");
  playerRun2 = loadImage("Characterv2Run3.png");
  playerShoot = loadImage("Characterv2Shoot.png");
  rockyBackground = loadImage("rockyBackground.png");
  dungeonFloor = loadImage("dungeonFloor.png");
  bloodSpatter = loadImage("bloodSpatter.png");
  
  //int buffersize = 256;
  minim = new Minim(this);
  jumpSnd = minim.loadSample("breathJump.mp3");
  shootSnd = minim.loadSample("synth_blast.wav");
  enemyDeathSnd = minim.loadSample("dying_enemy.wav");
  playerDeathSnd = minim.loadSample("dying_player.wav");
  
  // gotta find a better font
  f = createFont("impact", 30, true);
  
}


void draw()
{
  // draw the background first for every frame
  // if the player hits an enemy, flash the background red  
  
  // accidental motion blur effect with the tint
  // although shoing previous frames of the character might be better
  //tint(255, 64);
  image(rockyBackground, width/2, height/2);
  //noTint();
  
  for(int i = 0; i < enemyArray.size(); i++)
  {
    if(player.checkEnemyCollision(enemyArray.get(i)))
    {
      background(255, 0, 0);
      player.health--;
    }
  }
  //draw floor
  //tint(255, 128);
  image(dungeonFloor, 400, 343);
  //noTint();
  
  //draw the player
  imageMode(CENTER);
  player.draw();
  
  // create extra enemies depending on difficulty
  // need to figure out how to delay the enemies spawning
  if (respawnDelay == respawnTime && canSpawn == true)
  {
    enemyArray.add(new Enemy(difficulty));
    respawnDelay = 0;
    
    if(enemyArray.size() >= maxEnemies)
    {
      canSpawn = false;
    }
  }
  
  respawnDelay++;
  
  
  //draw the enemy
  imageMode(CENTER);
  for(int i = 0; i < enemyArray.size(); i++)
  {
    Enemy tempEnemy = enemyArray.get(i);
    tempEnemy.draw();
    tempEnemy.move();
  }
  
  //draw the bullet
  for(int i = 0; i < bulletArray.size(); i++)
  {
    Bullet tempBullet = bulletArray.get(i);
    if(tempBullet == null)
    {
      // not sure what to do here, since errors occur
      // when a null object isn't checked for
      //println("nobullets");
    }
    else{
      //draw each bullet
      tempBullet.draw();
      tempBullet.move();
      
      //check bullet collision
      for(int j = 0; j < enemyArray.size(); j++)
      {
        if(tempBullet.checkEnemyHit(enemyArray.get(j)))
        {
          score++;
          hits++;
          enemyDeathSnd.trigger();
          enemyArray.remove(j);
          canSpawn = true;
          respawnDelay = 0;
          bulletArray.remove(i);
        }
      }
      
      if(tempBullet.xPos >= width + tempBullet.w || tempBullet.xPos <= 0)
      {
        bulletArray.remove(i);
      }   
    } 
  }  
  player.checkMovement();
  
  theHUD.draw();
  
  if(player.health <= 0)
  {
    gameOver = true;
  }
  
  theScreen.draw();
  
}

void keyPressed()
{
    if(keyCode == UP)
    {
      // check if the player is on the ground, so that they can only jump once
      // might implement some kind of douple jump power up around here later
     if(player.isOnGround)
     {
        jumpSnd.trigger();
        player.jumping = true;
        player.isOnGround = false;
        player.falling = false;
     }
      player.isShooting = false;
    }
    
    if (keyCode == RIGHT)
    {
      player.runningRight = true;
      player.isShooting = false;
      player.facingRight = true;
    }
    
    if (keyCode == LEFT)
    {
      player.runningLeft = true;
      player.isShooting = false;
      player.facingRight = false;
    }
    
    // to shoot, press spacebar
    if(keyCode == ' ')
    {
      player.isShooting = true;
      bulletArray.add(new Bullet(player.xPos + 50, player.yPos, player));
      shootSnd.trigger();
      shotsFired++;
      fill(255, 255, 0, 64);
      ellipseMode(CENTER);
      if(player.facingRight)
      {
        ellipse(player.xPos + 20, player.yPos - 20, 50, 50);
      }
      else
      {
        ellipse(player.xPos - 20, player.yPos - 20, 50, 50);
      }
    }
    
    if(keyCode == ENTER)
    {
      gameOver = false;
      player.health = 50;
      score = 0;
      hits = 0;
      shotsFired = 0;
      deathCount = 0;
    }
}
  
void keyReleased()
{
    if (keyCode == RIGHT)
    {
      player.runningRight = false;
    }
    if (keyCode == LEFT)
    {
      player.runningLeft = false;
    }
    
    if (keyCode == UP)
    {
      player.jumping = false;
      player.falling = true;
    }
    
    // I need to figure out how to make some kind of delay here so that I can make an animation
    // for the gun coming down
    if(keyCode == ' ')
    {
      //player.isShooting = false;
    }
  
}

void stop()
{
  jumpSnd.close();
  shootSnd.close();
  enemyDeathSnd.close();
  playerDeathSnd.close();
  
  minim.stop();
  super.stop();
}


