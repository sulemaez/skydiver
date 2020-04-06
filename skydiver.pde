
//holds the screen to be shown
int screen = 0;
int WIDTH = 500;
int HEIGHT = 500;

//holds players current position
float playerX = WIDTH / 2 - 50;
float playerY = 0;

int points = 0;
int lives = 3;
PImage lifeImage;
int countAvoided = 0;

//time
float lastTimeStamp = 0;
float obstacleInterval = 4000;
PImage backGroundImage;

//obstacle
ArrayList<Obstacle> obstacles = new ArrayList();
ArrayList<Obstacle> removableObstacles = new ArrayList();
float obstacleSpeed = 0.4;
Player player;

//stars
ArrayList<Star> stars = new ArrayList();
ArrayList<Star> removableStars = new ArrayList();
float starSpeed = 0.6;

void settings(){
   size(500,500);
}
  

void setup() {
 
  backGroundImage = loadImage("sky.gif");  
  lifeImage = loadImage("life.png");
  lifeImage.resize(30,30);
  player = new Player();
  
}



void draw() {
  if (screen == 0) {
    initialScreen();
  } else if (screen == 1) {
    playScreen();
  } else if (screen == 2) {
    gameOverScreen();
  }
}

//screens
void initialScreen(){
  background(#87ceeb);
  textAlign(CENTER);
  textSize(60);
  text("SKY DIVER", height/2, width/2 - 50);
  textSize(20);
  text("Click mouse to start !", height/2, width/2);
 
}  

void playScreen(){
   background(backGroundImage);
   player.display(playerX,playerY);
   handleStars();
   handleObstacles();
  
    //get new points
    if(countAvoided == 4){
      points += 2;
      countAvoided = 0;
    }
    
    

  //draw res and lives
  textSize(16);
  fill(#00ff00);
  String p = "POINTS : "+ points;
  text(p,50,50);
  image(lifeImage,10,2);
  fill(#ff0000);
  text(""+lives,50,23);
  
 
}
void handleStars(){
  //generate new 
  int chance = int(random(1,10));
  
   if((chance == 7) && (millis() - lastTimeStamp > (obstacleInterval - 500))){
     stars.add(new Star());
  }
  

    for(int i = 0;i < stars.size() ; i++){
       //move
       stars.get(i).display(stars.get(i).getX(),stars.get(i).getY() - starSpeed);
       
       //check collision
       if(abs(stars.get(i).getX() - player.getX()) < 20 && abs(stars.get(i).getY() - player.getY()) < 80  ){
         
         removableStars.add(stars.get(i));
         stars.get(i).destroy();
         points += 10;
       }     
     
      //add to remove list remove
       if(stars.get(i).getY() < - 2){
         removableStars.add(stars.get(i));
         stars.get(i).destroy();
       }
     
    }
    stars.removeAll(removableStars); 
    removableStars.clear();
}


void handleObstacles(){
//handle obstacles
  //add new
  if(millis() - lastTimeStamp > obstacleInterval || lastTimeStamp == 0){
     lastTimeStamp = millis();
     int ob = int(random(0,3));
     
     obstacles.add(ob == 2 ? new Balloon(): new Bird());
  }
  
  //loop to ckeck all

 
  for(int i = 0 ; i < obstacles.size();i++){
     //move
     obstacles.get(i).display(obstacles.get(i).getX(),obstacles.get(i).getY() - obstacleSpeed);
     
     //check collision
     if(  (abs(obstacles.get(i).getX() - player.getX()) < 20 && abs(obstacles.get(i).getY() - player.getY()) < 80 && obstacles.get(i).type == 2) ||
        (abs(obstacles.get(i).getX() - player.getX()) < 40 && abs(obstacles.get(i).getY() - player.getY()) < 80 && obstacles.get(i).type == 1)){
       
       removableObstacles.add(obstacles.get(i));
       obstacles.get(i).destroy();
       
       //reduce life 
       lives--;
       if(lives == 0)endGame();
     }     
     
     //add to remove list remove
     if(obstacles.get(i).getY() < - 2){
       removableObstacles.add(obstacles.get(i));
       obstacles.get(i).destroy();
       
       countAvoided++;
     }
  }
  
  obstacles.removeAll(removableObstacles);
  removableObstacles.clear();
 

}

void gameOverScreen(){

  background(#87ceeb);
  textAlign(CENTER);
  textSize(60);
  text("Game Over", height/2, width/2 - 50);
  textSize(20);
  text("POINTS : "+points, height/2, width/2 -20);
  textSize(20);
  text("Click mouse to start !", height/2, width/2);
  
}  

//events
public void mousePressed() {
  // starts the game
  if (screen!=1) {
     intializeGame();
  }
}

void keyPressed() {
  if (screen == 1) {
      float tmp = playerX;
      switch(keyCode){
          case RIGHT:
             playerX = player.getX() + 10;
             if(playerX > WIDTH - 100)playerX = tmp;
             break;
          case LEFT:
             playerX = player.getX() - 10;
             if(playerX < 0)playerX = tmp;
             break;
         default:
            break;
      } 
  }
}


//
void intializeGame(){
  screen = 1;
  points = 0;
  lives = 3;
}
void endGame(){
  screen = 2;
}


//player class

class Player {
  PImage sprite;  
  float x;
  float y;
  
  Player() {
    
    sprite = loadImage("man2.png");
    sprite.resize(80,80);

  }

  void display(float x, float y) {
    this.x = x;
    this.y = y;
    image(sprite, x, y);
  }
  
 float getX(){
    return x;
  }
  
  float getY(){
    return y;
  }
  
  int getWidth() {
    return sprite.width;
  }
  
}

//obstacle class
class Obstacle {
  PImage sprite;
  PImage[] sprites;
  int count;
  float x;
  float y;
  int type;
  int frame;
  
  Obstacle(int type){
     x = random(0,500 - 100);
     y = HEIGHT + 1;
     this.type = type;
     if(type == 1){
        sprite = loadImage("balloon.png");
        sprite.resize(60,60);
        image(sprite,x,y);
     }else{
 
       sprites = new PImage[3];
       sprites[0] = loadImage("b1.png");
       sprites[1] = loadImage("b2.png");
       sprites[2] = loadImage("b3.png");
       count = 1;
       frame = 0;
       sprites[0].resize(30,30);
       sprites[1].resize(30,30);
       sprites[2].resize(30,30);
       image(sprites[count],x,y);
     }
     
  }  
  
  void display(float x, float y) {
      this.x = x;
      this.y = y;
      
      if(type == 1){
        image(sprite,x,y);
      }else{
       count++;
       if(count  == 10){
          count = 1;
          frame++;
          if(frame > 2) frame = 0;  
       }
       image(sprites[frame],x,y);
     }
  }
  
  void destroy(){
    this.x = -30;
    this.y = -30;
  } 
  
  float getX(){
    return x;
  }
  
  float getY(){
    return y;
  }
  

}

//balloon
class Balloon extends Obstacle{
  
   Balloon(){
     super(1);
   }   
   
}

class Bird extends Obstacle{
  
   Bird(){
     super(2);
   }   
   
}

class Star{
  
  PImage sprite;
  int count;
  float x;
  float y;
 
  
  Star(){
     x = random(0,500 - 100);
     y = HEIGHT + 1;
   
     sprite = loadImage("star.png");
     sprite.resize(60,60);
     image(sprite,x,y);

  }  
  
  void display(float x, float y) {
      this.x = x;
      this.y = y;
      
      image(sprite,x,y);   
  }
  
  void destroy(){
    this.x = -30;
    this.y = -30;
  } 
  
  float getX(){
    return x;
  }
  
  float getY(){
    return y;
  }
}
