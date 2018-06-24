import processing.serial.*;
Serial myPort;

ArrayList<Integer> x;
ArrayList<Integer> y;

int wid,hei,bs;
int points,eat;
int ballX,ballY;
int speed,level;
int bgColor,whiteOrRED;
int dir;
int[]dx = {0,0,1,-1},dy = {1,-1,0,0};//{DOWN,UP,RIGHT,LEFT}
int oldpush = 0;
int noleft = 0;
int noright = 0;
int best=0;

boolean gameOver,start,tooClose;
PImage spSEL;
PImage stD;
PImage apple;
PImage snackR;
PImage snackU;
PImage snackD;
PImage snackL;
PImage gameBg;
PImage gameBgRed;
PImage gameOverImg;


  void setup(){
  size(800,800);
//  myPort = new Serial(this, Serial.list()[0], 115200); 
  spSEL = loadImage("levelSelect.jpg");
  stD = loadImage("startDown.jpg");
  apple = loadImage("appleSmall.jpg");
  snackR = loadImage("snackHeadRight.jpg");
  snackU = loadImage("snackHeadUp.jpg");
  snackD = loadImage("snackHeadDown.jpg");
  snackL = loadImage("snackHeadLeft.jpg");
  gameBg = loadImage("BackgruandGame.jpg");
  gameBgRed = loadImage("BackgruandGameRed.jpg");
  gameOverImg = loadImage("GameOver.jpg");

   StartGame();
}

void StartGame(){
        wid=40;
        hei=40;
        bs=20;
        points = 0;
        eat = 0;
        ballX = 10;
        ballY = 10;
        speed = 5;
        level = 1;
        bgColor = 70;
        whiteOrRED = 255;
        dir = 2;
        gameOver = false;
        start = false;
        tooClose = false;
        x = new ArrayList<Integer>();
        y = new ArrayList<Integer>();
        
        x.add(20);
        y.add(23);
}

void open(){
    image(spSEL, 0, 0);
    textSize(40);
    fill(255, 0, 0);
    text("speed: " + level,310,400);  
    image(stD, 0, 500);
}

void draw(){
  
    int push = myPort.read();
    int left = 0;
    int right = 0;
    
    if(push==76 && push!=noleft){
      noleft = push;
      right = 0;
      left = 1;
    }
    if(push==82 && push!=noright){
      noright = push;
      left = 0;
      right = 1;
    }
    if(push==78)
      noleft = 78;
    if(push==69)
      noright=69;
      
    if(!start){
      if(keyPressed){
          //keyboard, choose level.
        if(key=='1')
          level = 1;
        if(key=='2')
          level = 2;
        if(key=='3')
          level = 3;
        if(key=='4')
          level = 4;
        if(key=='5')
          level = 5;
      }
      if(keyCode==ENTER){//space
       //keyboard,start game.
         start=true;
       if(level==1) speed=6;
       if(level==2) speed=5;
       if(level==3) speed=4;
       if(level==4) speed=3;
       if(level==5) speed=2;
       dir=2;
     }
     if(right==1){
       //chip, choose level.
       level++;
       if(level+1==7 && right==1){
         level=1;
       }
     }
     if(left==1){
       //chip,start game.
       start=true;
       if(level==1) speed=6;
       if(level==2) speed=5;
       if(level==3) speed=4;
       if(level==4) speed=3;
       if(level==5) speed=2;
       dir=0;
     }
    }
    if(right==1){
    if(dir==0)
      dir=3;
    else if(dir==1)
      dir=2;
    else if(dir==2)
      dir=0;
    else
      dir=1;
    }
    if(left==1){
    if(dir==0)
      dir=2;
    else if(dir==1)
      dir=3;
    else if(dir==2)
      dir=1;
    else
      dir=0;
    }
   
  background(bgColor);
  stroke(bgColor);
  fill(0);
  
  for(int i=0; i<wid;i++){
    line(i*bs,0,i*bs,height);
  }
  for(int i=0;i<hei;i++){
    line(0,i*bs,width,i*bs);
  }
  
  if(points>best){
   best=points;
  }

  
  if(!gameOver){
    if(start==false){
       open();
    }
  if(start){ 
  if(tooClose==true)
      background(gameBgRed);
  else
      background(gameBg);

  textSize(30);
  fill(255, whiteOrRED, whiteOrRED);
  text(points,110,45);
  text(best,405,45);
  text(level,770,45);
  }
    
  //snake colors
  for(int i=0;i<x.size();i++){
   if(i%3==0){
   fill(0,0,0);
   rect(x.get(i)*bs,y.get(i)*bs,bs,bs);
   }
   if(i%3==1){
   fill(255,239,0);
   rect(x.get(i)*bs,y.get(i)*bs,bs,bs);
   }
   if(i%3==2){
   fill(255,0,0);
   rect(x.get(i)*bs,y.get(i)*bs,bs,bs);
   }
   if(dir==2)
   image(snackR, x.get(0)*bs,y.get(0)*bs);
   if(dir==1)
   image(snackU, x.get(0)*bs,y.get(0)*bs);
   if(dir==3)
   image(snackL, x.get(0)*bs,y.get(0)*bs);
   if(dir==0)
   image(snackD, x.get(0)*bs,y.get(0)*bs);

  
  }
  if(x.get(0)==0 || x.get(0)==wid-1 || y.get(0)==hei-4 || y.get(0)==3){
    myPort.write(48);//light on
    whiteOrRED = 0;
    tooClose=true;
  }
  else{
    myPort.write(49);//light off
    whiteOrRED = 255;
    tooClose=false;
  }

  if(x.get(0)<0 || y.get(0)<3 || x.get(0)>=wid || y.get(0)>=hei-3){
    gameOver=true;
  }
   for(int i=2;i<x.size();i++){
    if(x.get(0)==x.get(i) && y.get(0)==y.get(i))
      gameOver=true;
   }
  if(frameCount%speed==0 && start){
    x.add(0,x.get(0)+dx[dir]);
    y.add(0,y.get(0)+dy[dir]); 
    x.remove(x.size()-1);
    y.remove(y.size()-1);
  }
   if(x.get(0)==ballX && y.get(0)==ballY){
      ballX = (int)random(0,wid);
      ballY = (int)random(3,hei-4);
      
      for(int i=0;i<x.size();i++){
        if(ballX==x.get(i) && ballY==y.get(i)){
            ballX = (int)random(0,wid);
            ballY = (int)random(3,hei-4);
        }
      }
      
      x.add(0,x.get(0));
      y.add(0,y.get(0));
      eat++;
      if(eat==10 && level<5){
       speed--;
       level++;
       eat=0;
      }
      if(level==1){
      points++;  
      }
      else if(level==2){
      points=points+2; 
      }
      else if(level==3){
      points=points+3; 
      }
      else if(level==4){
      points=points+4; 
      }
      else if(level==5){
      points=points+5; 
      }
   }
   
  if(start){
  image(apple, ballX*bs, ballY*bs);
  }
  }
  if(gameOver && start){
   //game over 
    background(gameOverImg);
    
    for(int i=0;i<x.size();i++){
   if(i%3==0){
   fill(0,0,0);
   rect(x.get(i)*bs,y.get(i)*bs,bs,bs);
   }
   if(i%3==1){
   fill(255,239,0);
   rect(x.get(i)*bs,y.get(i)*bs,bs,bs);
   }
   if(i%3==2){
   fill(255,0,0);
   rect(x.get(i)*bs,y.get(i)*bs,bs,bs);
   }
   if(dir==2)
   image(snackR, x.get(0)*bs,y.get(0)*bs);
   if(dir==1)
   image(snackU, x.get(0)*bs,y.get(0)*bs);
   if(dir==3)
   image(snackL, x.get(0)*bs,y.get(0)*bs);
   if(dir==0)
   image(snackD, x.get(0)*bs,y.get(0)*bs);

  
  }

    textSize(30);
    fill(255, 0, 0);
    text(points,110,45);
    text(best,405,45);
    text(level,770,45);
        
    if(keyPressed){
    if(key==32){
      x.clear();
      y.clear();
      StartGame();
      open();
      }
    }

  }
}

void keyPressed(){
  int newdir = CODED;
  if(key==CODED){
    
   if(keyCode==DOWN && dir!=1)
     newdir = 0;
    else if(keyCode==DOWN && dir==1)
      newdir = 1;
   else if(keyCode==UP && dir!=0)
     newdir = 1;
    else if(keyCode==UP && dir==0)
      newdir = 0;
   else if(keyCode==RIGHT && dir!=3)
     newdir = 2;
     else if(keyCode==RIGHT && dir==3)
       newdir = 3;
    else if(keyCode==LEFT && dir!=2)
     newdir = 3;
     else if(keyCode==LEFT && dir==2)
     newdir = 2;
    else
      newdir = dir;

  if(newdir!=-1)
    dir = newdir;
    
  }
  
}
