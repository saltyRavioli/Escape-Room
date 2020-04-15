// Nathan Lu
// 12/20/18
// ICS2O3-01 (Mr. Rosen)
// This program is an escape room game.  This is the final version.  It is fully functional.

// Declaring global variables

//   Character positioning variables
int xPos=180;
int yPos=230;
int keyX;
int keyY;
int xVelocity=3;
int yVelocity=500;
//    The previous position variables are for restoring the previous position if the player collides with the wall
int xPosPrev;
int yPosPrev;
//    System variables
char programState; //this variables stores what function should run when (ie. when play game is selected from the main menu, program state is set to 1)
boolean isPlayGamePressed=false;
int timer=0; //this is not used for timing the player; it is used to to store the time since the last interacton with buttons, doors, etc.
char latestKeyPressed;

//   Player statistic variables:
int roomIndex=0; //Which room is the player in?
boolean hasHammer; //Does the player have the hammer item from room 4?
int mana=600;
boolean gender; //For the character select screen
int countdown = 36000; //the countdown variable is for timing the player; if it reaches 0, the player loses

//    The entered room variables will store if the player has entered the puzzle rooms yet.  It will be used to make the introductory message for each room dissapear.
boolean enteredStartingRoom;
boolean enteredRoom1;
boolean enteredRoom2;
boolean enteredRoom3;
boolean enteredRoom4;

//    The get key variable determines whether the user has gotten the key for the room
boolean getKeyStart=false;
boolean getKey1=false;
boolean getKey2=false;
boolean getKey3=false;
boolean getKey4=false;

//    Room specific variables
int roomState; //for the maze in room 1
boolean collisionRoom2=true; //for the maze in room 2;
boolean barrier1Destroyed; //for the maze in room 3;
boolean barrier2Destroyed; //for the maze in room 3;
boolean barrier3Destroyed; //for the maze in room 3;

//   Animation related
int animationNo=0; //for which animation position the player is in
int animationNo1; //for which animation position the first NPC is in
int animationNo2; //for which animation position the second NPC is in
int animationNo3; //for which animation position the third NPC is in
int animationNo4; //for which animation position the fourth NPC is in

//   Picture arrays
PImage [ ]playerStanding = new PImage [6];
PImage [ ]playerWalking = new PImage [2];
PImage playerDash;
PImage [ ]playerItemGet = new PImage [2];
//      The next four arrays store the sprites of all the positions of the noblemen
PImage [ ]noble1Positions = new PImage [2];
PImage [ ]noble2Positions = new PImage [2];
PImage [ ]noble3Positions = new PImage [2];
PImage [ ]noble4Positions = new PImage [2];
PImage [ ]rooms = new PImage [10]; //This stores the room layouts as well as the background images used in the game.
PImage [ ]items = new PImage [2]; //This stores the item sprites in the game
PImage [ ]guards = new PImage [2]; //This stores the sprites of the guards of the dungeon in the game

void splashScreen() {
  background(0);
  if (timer>160) {
    programState='0';
    timer=0;
  } else {
    rectMode(CORNERS);
    xVelocity+=6;
    yVelocity-=3;
    for (int x=1000; x>=0; x-=250) {
      fill(x/4);
      noStroke();
      rect(0, 0, x+xVelocity, 500);
    }
    textSize(25);
    fill(255);
    textAlign(CENTER);
    text("A Hasty Escape", 400, yVelocity);
  }
}


void mainMenu() {
  background(0);
  text("A Hasty Escape", 400, 20);
  //Making the rectangles that appear if the mouse hovers over the opotions
  fill(100);
  stroke(0);
  rectMode(CORNERS);
  if (mouseX>300 && mouseX<500 && mouseY>60 && mouseY<120) {
    rect(300, 60, 500, 120);
  } else if (mouseX>300 && mouseX<500 && mouseY>160 && mouseY<220) {
    rect(300, 160, 500, 220);
  } else if (mouseX>300 && mouseX<500 && mouseY>260 && mouseY<320) {
    rect(300, 260, 500, 320);
  } else if (mouseX>220 && mouseX<600 && mouseY>360 && mouseY<420) {
    rect(220, 360, 600, 420);
  }
  //Writing the options
  textSize(25);
  textAlign(CENTER);
  fill(225);
  text("1. Play game", 400, 100);
  text("2. Instructions", 400, 200);
  text("3. Backstory", 400, 300);
  text("   Press any other key to exit", 400, 400);
  if (timer>60) {
    if (keyPressed||mousePressed) {
      if ((key=='1')||(mouseX>300 && mouseX<500 && mouseY>55 && mouseY<110)) {
        isPlayGamePressed=true;
        programState='1';
        timer=0;
      } else if ((key=='2')||(mouseX>300 && mouseX<500 && mouseY>170 && mouseY<230)) {
        programState='2';
        timer=0;
      } else if ((key=='3')||(mouseX>300 && mouseX<500 && mouseY>260 && mouseY<315)) {
        programState='3';
        timer=0;
      } else if (mouseX>220 && mouseX<600 && mouseY>360 && mouseY<420) {
        programState='5';
        timer=0;
      }
    }
  }
  timer++;
}

void instructions() {
  background(0);
  fill(255);
  textSize(35);
  text ("CONTROLS", 400, 50); 
  noFill();
  stroke(255);
  strokeWeight(2);
  //drawing the rectangles for the arrow key diagrams
  rect (150, 100, 225, 175, 30);
  rect (150, 190, 225, 265, 30);
  rect (60, 190, 135, 265, 30);
  rect (240, 190, 315, 265, 30);
  //drawing the 'WASD'
  textSize(24);
  text('W', 187, 150);
  text('S', 187, 240);
  text('A', 100, 240);
  text('D', 280, 240);
  //writing "use 'WASD' to move"
  fill(255);
  textSize(25);
  text("use 'WASD' to move", 500, 187);
  //drawing the 'Q' key
  noFill();
  rect (150, 340, 225, 415, 30);
  textSize(24);
  text ('Q', 188, 385);
  text ("Press the 'Q' key to interact with the environment", 300, 345, 700, 440);
  if (timer>60) {
    if (keyPressed||mousePressed) {
      if (isPlayGamePressed==true) {
        timer=0;
        programState='3';
      } else if (programState=='2') {
        timer=0;
        programState='0';
      }
    }
  }
  timer++;
}

void backstory() {
  background(0);
  textSize(25);
  text("Backstory", 400, 50);
  if (timer>60) {
    if (keyPressed||mousePressed) {
      if (isPlayGamePressed==true) {
        timer=0;
        programState='4';
      } else if (programState=='3') {
        timer=0;
        programState='0';
      }
    }
  }
  textSize(19);
  text("The mythical land of Elysium has achieved such a complete peace and happiness that it has forgotten about the dark tribe hidden at its corners.  The tribe lashed out, swiftly conquering the kingdom.", 100, 100, 700, 170);
  text("The land has five major ministers: the king, the queen, the economist, the general, and the magician.", 100, 175, 700, 270);
  text("These five have been thrown into the most magically secured dungeon in the kingdom, but what does a dark tribe know about magic?", 100, 245, 700, 370);
  text("You are the current magician of the land, and within an hour you have broken most of the spells confining you to your cell, but you realize that you can only keep your counter spells up for 10 minutes.  Can you free everyone and escape in that time?", 100, 370, 700, 490);
  timer++;
}

void chooseCharacter() {
  background(0);
  text("Choose your character:", 400, 50);
  image(playerStanding[0], 200, 300);
  text("Male", 260, 350);
  image(playerStanding[3], 550, 300);
  text("Female", 640, 350);
  if (timer>60) {
    if (mousePressed) {
      if (dist(mouseX, mouseY, 200, 300)<100) {
        gender=true;
        programState='6';
      } else if (dist(mouseX, mouseY, 550, 300)<100) {
        gender=false;
        programState='6';
      }
    }
    timer++;
  }
}

void startingRoom () {
  background(rooms[0]);
  //Intro message
  if (enteredStartingRoom==false) {
    if (keyPressed==false || timer<60) {
      xPos=600;
      yPos=250;
      fill(0);
      rectMode(CORNERS);
      noStroke();
      rect(200, 200, 600, 300);
      fill(255);
      textAlign(CENTER);
      text("This is the training room; try getting close to the key and drag it with the mouse to the entrance at the right side of the room. You must also get yourself to the door to pass this level.", 200, 200, 600, 300);
    }
  }
  if (keyPressed==true && timer>60) {
    enteredStartingRoom=true;
  }

  //Key-related
  //  Placing the key
  if (getKeyStart==false) {
    image(items[0], 552, 150);
  }
  //  Activating the key
  if (dist(xPos, yPos, 552, 150)<50) { //Is the player close to the key
    if (mousePressed==true && dist(mouseX, mouseY, 552, 150)<50) {//Is the mouse pressed and close to the key
      getKeyStart=true;
    }
  }
  //  Moving the key with the mouse
  if (getKeyStart==true) {
    if (mousePressed==true) {
      keyX=mouseX;
      keyY=mouseY;
    }
    image(items[0], keyX, keyY);
  }
  //  Is the key at the door (with the player avatar)?
  if (xPos>600 && yPos>185 && yPos<290 && keyX>600 && keyY>185 && keyY<290) {
    print("complete");
    timer=0;
    xPos=500;
    yPos=230;
    roomIndex=1;
  }
  //collisions
  if (xPos<673 && xPos>638 && yPos>195 && yPos<281) { //entrance collision
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos>663 || xPos<81 || yPos<94 || yPos>382) { //room wall collision
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos<246 && yPos<148) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos<246 && yPos>327) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos<246 && xPos>210 && yPos<220) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos<246 && xPos>210 && yPos>250) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos>270 && xPos<375 && yPos<223 && yPos>106) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos>502 && xPos<633 && yPos<203 && yPos>115) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos>552 && xPos<603 && yPos<118) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else {
    xPosPrev=xPos;
    yPosPrev=yPos;
  }
}

void lobby() {
  background(67);
  int radius = 200;
  int holeRadius = 80;
  int centreX = 400;
  int centreY = 250;
  //the lobby is made in Processing and is not a PImage because it's easier to adjust to the collisions this way
  fill(154);
  noStroke();
  ellipseMode(RADIUS);
  ellipse (centreX+5, centreY+9, radius+3, radius+10);
  fill(67);
  ellipse (centreX+5, centreY+10, holeRadius-5, holeRadius-10);
  fill(154);
  for (int angle=0; angle<=360; angle+=90) {
    pushMatrix();
    translate(centreX+5, centreY+9);
    rotate(radians(angle));
    rect(-25, radius, 25, radius+20);
    popMatrix();
  }
  pushMatrix();
  translate(centreX+5, centreY+9);
  rect(-25, holeRadius, 25, holeRadius-25);
  popMatrix();
  if (xPos>580 && xPos<615 && yPos<260 && yPos>233) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } else if (xPos>380 && xPos<420 && yPos<460 && yPos>380) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } else if (xPos<210 && xPos>180 && yPos<263 && yPos>233) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } else if (xPos>380 && xPos<420 && yPos<60 && yPos>40) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } else if (xPos>380 && xPos<424 && yPos<340 && yPos>313) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } else if (dist(xPos, yPos, centreX, centreY)>radius) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (dist(xPos, yPos, centreX, centreY)<holeRadius) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else {
    xPosPrev=xPos;
    yPosPrev=yPos;
  }

  //activating the rooms
  if (xPos>580 && xPos<615 && yPos<260 && yPos>233 && (key=='Q'||key=='q')) { //first room
    roomIndex=2;
    timer=0;
    mana=600;
    xPos=600;
    yPos=250;
  } else if (xPos>380 && xPos<420 && yPos<460 && yPos>400 && (key=='Q'||key=='q')) { //second room
    roomIndex=5;
    mana=600;
    timer=0;
    xPos=600;
    yPos=250;
    collisionRoom2=true;
  } else if (xPos<210 && xPos>180 && yPos<263 && yPos>233 && (key=='Q'||key=='q')) { //third room
    roomIndex=6;
    mana=600;
    timer=0;
    xPos=600;
    yPos=250;
  } else if (xPos>380 && xPos<420 && yPos<60 && yPos>40 && (key=='Q'||key=='q')) { //4th room
    roomIndex=7;
    mana=600;
    timer=0;
    xPos=600;
    yPos=235;
    xPosPrev=600;
    yPosPrev=235;
  } else if (xPos>380 && xPos<424 && yPos<340 && yPos>313 && (key=='Q'||key=='q') && getKey1==true && getKey2==true && getKey3==true && getKey4==true) {
    exitScreen();
  }
}
void userInput() {
  if (roomIndex==5) {
    if (keyPressed==true && enteredRoom2==true) {
      if (collisionRoom2==true && (key=='w'||key=='W'||key=='s'||key=='S'||key=='a'||key=='A'||key=='d'||key=='D')) {
        latestKeyPressed=key;
        collisionRoom2=false;
      }
    }
    if (collisionRoom2==false) {
      if ((latestKeyPressed=='w'||latestKeyPressed=='W')) {
        yPos-=3;
      }
      if ((latestKeyPressed=='s'||latestKeyPressed=='S')) {
        yPos+=3;
      }
      if ((latestKeyPressed=='a'||latestKeyPressed=='A')) {
        xPos-=3;
      }
      if ((latestKeyPressed=='d'||latestKeyPressed=='D')) {
        xPos+=3;
      }
    }
  } else {
    if (keyPressed==true) {
      if (key=='w'||key=='W') {
        yPos-=3;
      }
      if (key=='s'||key=='S') {
        yPos+=3;
      }
      if (key=='a'||key=='A') {
        xPos-=3;
      }
      if (key=='d'||key=='D') {
        xPos+=3;
      }
    }
  }
}
void display() {
  //drawing the player avatar
  if (keyPressed==false) {
    if ((key=='w'||key=='W'||key=='a'||key=='A')) {
      if (gender==true) {
        image(playerStanding[0], xPos-4, yPos-4, height/27, width/27);
      } else if (gender==false) {
        image(playerStanding[3], xPos-4, yPos-8, height/15, width/18);
      }
    } else if ((key=='s'||key=='S'||key=='d'||key=='D')) {
      if (gender==true) {
        image(playerStanding[1], xPos-4, yPos-4, height/27, width/27);
      } else if (gender==false) {
        image(playerStanding[4], xPos-4, yPos-4, height/20, width/20);
      }
    } else if (key=='q'||key=='Q') {
      if (gender==true) {
        image(playerStanding[2], xPos-4, yPos-4, height/23, width/23);
      } else if (gender==false) {
        image(playerStanding[5], xPos-4, yPos-4, height/27, width/27);
      }
    }
  } else if (key=='q'||key=='Q') {
    if (gender==true) {
      image(playerStanding[2], xPos-4, yPos-4, height/23, width/23);
    } else if (gender==false) {
      image(playerStanding[5], xPos-4, yPos-4, height/27, width/27);
    }
  } else {
    if (animationNo<30) {
      if ((key=='w'||key=='W'||key=='a'||key=='A'))
        image(playerWalking[0], xPos, yPos-2);
      else if ((key=='s'||key=='S'||key=='d'||key=='D')) {
        pushMatrix();
        translate(xPos, yPos-2);
        rotate(radians(180));
        image(playerWalking[0], -15, -25);
        popMatrix();
      }
    } else if (animationNo<60) {
      if ((key=='w'||key=='W'||key=='a'||key=='A'))
        image(playerWalking[1], xPos, yPos+2);
      else if ((key=='s'||key=='S'||key=='d'||key=='D')) {
        pushMatrix();
        translate(xPos, yPos+2);
        rotate(radians(180));
        image(playerWalking[1], -15, -25);
        popMatrix();
      }
    } else {
      animationNo=0;
    }
    animationNo++;
  }
  //drawing the mana bar
  textSize(16);
  fill(255);
  text("Mana", 50, 20);
  stroke(32, 178, 170);
  for (int x=0; x<mana; x++) {
    line(80+x, 0, 80+x, 20);
  }
  //Displaying whether the hammer has been collected:
  text("Items", 730, 170, 790, 300);
  textSize(10);
  text("Click on to check description", 730, 190, 790, 350);
  if (hasHammer==true) {
    image(items[1], 750, 250);
  }
  //Displaying the description screen
  if (mousePressed==true && dist(mouseX, mouseY, 750, 250)<50 && hasHammer==true) {
    fill(0);
    rectMode(CORNERS);
    noStroke();
    rect(680, 230, 780, 300);
    fill(255);
    textSize(11);
    textAlign(CENTER);
    text("Allows you to smash boulders without any mana cost", 680, 230, 780, 300);
  }
  //Displaying the time left in seconds
  textSize(10);
  text("time remaining:", 50, 50);
  text(countdown/60 + " seconds", 130, 50);
  //If timer runs out
  if (countdown<0) {
    programState='5';
    println("runs");
  }
}


void room1() {
  //room switching
  if (keyPressed==true) {
    if (timer>60) {
      if (key=='q'||key=='Q') {
        if (mana==0) {
          xPos=579;
          yPos=250;
          roomIndex=1;
        } else {
          timer=0;
          roomIndex++;
          mana-=50;
          if (roomIndex>4) {
            roomIndex=2;
          }
        }
      }
    }
  }
  background(rooms[roomIndex]);
  //intro message
  textSize(11);
  if (enteredRoom1==false) {
    if (keyPressed==false || timer<60) {
      fill(0);
      rectMode(CORNERS);
      noStroke();
      rect(200, 200, 600, 300);
      fill(255);
      textAlign(CENTER);
      text("This is the first room. To finish this level, both you and the key must be near the locked door at the end of the room. This room has three different blockade arrangements, and press 'Q' to switch between the arrangements.", 200, 200, 600, 300);
    }
  }
  if (keyPressed==true && timer>60) {
    enteredRoom1=true;
  }

  //displaying the minimap
  image(rooms[roomIndex], 470, 420, width/6, height/6);
  int nextRoom=roomIndex;
  for (int x=1; x<=2; x++) { //Printing the next two rooms
    nextRoom++;
    if (nextRoom>4) {
      nextRoom=2;
    }
    image(rooms[nextRoom], 500+(100*x), 435, width/9, height/9);
  }
  text("Current arrangement:", 450, 424);
  text("Upcoming arrangements:", 650, 424);

  //Key-related
  //  Placing the key
  if (getKey1==false) {
    image(items[0], 200, 360);
  }
  //  Activating the key
  if (roomIndex==4 && dist(xPos, yPos, 200, 360)<50) { //Is the player in the correct room form and close to the key
    if (mousePressed==true && dist(mouseX, mouseY, 200, 360)<50) {//Is the mouse pressed and close to the key
      getKey1=true;
    }
  }
  //  Moving the key with the mouse
  if (getKey1==true) {
    if (mousePressed==true) {
      keyX=mouseX;
      keyY=mouseY;
    }
    image(items[0], keyX, keyY);
  }
  //  Is the key at the door (with the player avatar)?
  if (xPos>160 && xPos<210 && yPos>200 && yPos<280 && keyX>160 && keyX<210 && keyY>200 && keyY<280) {
    room1Complete();
  }
  //Leaving the room
  if (xPos<693 && xPos>618 && yPos>175 && yPos<301 && (key=='Q'||key=='q')) { //if player is near the entrance and presses 'q'
    roomIndex=1;
    xPos=570;
    yPos=250;
    xPosPrev=570;
    yPosPrev=250;
  } 
  //collisions
  if (xPos<673 && xPos>638 && yPos>195 && yPos<281) { //entrance collision
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos>663 || xPos<177 || yPos<94 || yPos>382) { //room wall collision
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } 
  //form specific collisions
  if (roomIndex==2) {
    if (xPos>544 && xPos<603 && yPos>75 && yPos<219) {
      println("collision");
      xPos=xPosPrev;
      yPos=yPosPrev;
      if (timer<10) {
        xPos=579;
        yPos=250;
        roomIndex=1;
        timer=0;
      }
    } else if (xPos>544 && xPos<603 && yPos>262) {
      println("collision");
      xPos=xPosPrev;
      yPos=yPosPrev;
      if (timer<10) {
        xPos=579;
        yPos=250;
        roomIndex=1;
        timer=0;
      }
    } else if (xPos>372 && xPos<495 && yPos>133) {
      println("collision");
      xPos=xPosPrev;
      yPos=yPosPrev;
      if (timer<10) {
        xPos=579;
        yPos=250;
        roomIndex=1;
        timer=0;
      }
    } else if (xPos<324 && yPos<280 && yPos>170) {
      println("collision");
      xPos=xPosPrev;
      yPos=yPosPrev;
      if (timer<10) {
        xPos=579;
        yPos=250;
        roomIndex=1;
        timer=0;
      }
    } else if (xPos<375 && yPos>275) {
      println("collision");
      xPos=xPosPrev;
      yPos=yPosPrev;
      if (timer<10) {
        xPos=579;
        yPos=250;
        roomIndex=1;
        timer=0;
      }
    } else if (xPos<323 && yPos<160) {
      println("collision");
      xPos=xPosPrev;
      yPos=yPosPrev;
      if (timer<10) {
        xPos=579;
        yPos=250;
        roomIndex=1;
        timer=0;
      }
    } else {
      xPosPrev=xPos;
      yPosPrev=yPos;
    }
  }

  if (roomIndex==4) {
    if (xPos>253 && xPos<302 && yPos>94 && yPos<250) {
      xPosPrev=xPos;
      yPosPrev=yPos;
    } else if (xPos<486 && yPos>340) {
      xPosPrev=xPos;
      yPosPrev=yPos;
    } else if (xPos>253 && xPos<302 && yPos>94 && yPos<250) {
      xPosPrev=xPos;
      yPosPrev=yPos;
    } else if (xPos<300 && yPos>220 && yPos<250) {
      xPosPrev=xPos;
      yPosPrev=yPos;
    } else if (xPos>602) {
      xPosPrev=xPos;
      yPosPrev=yPos;
    } else {
      println("collision");
      xPos=xPosPrev;
      yPos=yPosPrev;
      if (timer<10) {
        xPos=579;
        yPos=250;
        roomIndex=1;
        timer=0;
      }
    }
  }

  if (roomIndex==3) {
    if (xPos<485 && xPos>339 && yPos>343) {
      xPosPrev=xPos;
      yPosPrev=yPos;
    } else if (xPos>339 && xPos<392 && yPos>=259 && yPos<=343) {
      xPosPrev=xPos;
      yPosPrev=yPos;
    } else if (xPos>339 && xPos<486 && yPos>220 && yPos<259) {
      xPosPrev=xPos;
      yPosPrev=yPos;
    } else if (xPos>253 && xPos<488 && yPos<134) {
      xPosPrev=xPos;
      yPosPrev=yPos;
    } else if (xPos>602) {
      xPosPrev=xPos;
      yPosPrev=yPos;
    } else {
      println("collision");
      xPos=xPosPrev;
      yPos=yPosPrev;
      if (timer<10) {
        xPos=579;
        yPos=250;
        roomIndex=1;
        timer=0;
      }
    }
  }
}

void room1Complete() {
  mana=600;
  println("Congradulations!");
  background(0);
  xPos=600;
  yPos=250;
  xPosPrev=600;
  yPosPrev=250;
  roomIndex=1;
  timer=0;
  textAlign(CENTER);
  xPos=175;
  yPos=223;
  keyX=175;
  keyY=223;
  if (mousePressed==true || keyPressed==true) {
    println("Congradulations! You broke it!");
    background(0);
    textAlign(CENTER);
    xPos=175;
    yPos=223;
    keyX=175;
    keyY=223;
  }
  text("Congradulations!", 400, 50);
}

void room2() {
  background(rooms[5]);
  //intro message
  textSize(11);
  if (enteredRoom2==false) {
    if (keyPressed==false || timer<60) {
      xPos=600;
      yPos=250;
      fill(0);
      rectMode(CORNERS);
      noStroke();
      rect(200, 200, 600, 300);
      fill(255);
      textAlign(CENTER);
      text("This room is completely covered in ice. If you move in a direction, you will slide until you hit a wall or a blockade. To finish this level, both you and the key must be near the locked door at the end of the room.", 200, 200, 600, 300);
    }
  }
  if (keyPressed==true && timer>60) {
    enteredRoom2=true;
  }
  //Key-related
  //  Placing the key
  if (getKey2==false) {
    image(items[0], 200, 360);
  }
  //  Activating the key
  if (dist(xPos, yPos, 200, 360)<50) { //Is the player in the correct room form and close to the key
    if (mousePressed==true && dist(mouseX, mouseY, 200, 360)<50) {//Is the mouse pressed and close to the key
      getKey2=true;
    }
  }
  //  Moving the key with the mouse
  if (getKey2==true) {
    if (mousePressed==true) {
      keyX=mouseX;
      keyY=mouseY;
    }
    image(items[0], keyX, keyY);
  }
  //  Is the key at the door (with the player avatar)?
  if (dist (178, 240, xPos, yPos)<25 && dist (178, 240, keyX, keyY)<25 && collisionRoom2==true && getKey2==true) {
    room2Complete();
  }
  //Leaving the room
  if (xPos<693 && xPos>618 && yPos>175 && yPos<301 && (key=='Q'||key=='q')) { //if player is near the entrance and presses 'q'
    roomIndex=1;
    xPos=400;
    yPos=370;
    xPosPrev=400;
    yPosPrev=370;
  } 
  //collisions
  if (xPos<673 && xPos>638 && yPos>195 && yPos<281) { //entrance collision
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
    collisionRoom2=true;
  } else if (xPos>663 || xPos<177 || yPos<94 || yPos>382) { //room wall collision
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
    collisionRoom2=true;
  } else if (xPos>516 && xPos<582 && yPos>181 && yPos<295) { 
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
    collisionRoom2=true;
  } else if (xPos>474 && xPos<549 && yPos>80 && yPos<151) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
    collisionRoom2=true;
  } else if (xPos>399 && xPos<480 && yPos>277 && yPos<355) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
    collisionRoom2=true;
  } else if (xPos>237 && xPos<302 && yPos>232 && yPos<328) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
    collisionRoom2=true;
  } else if (xPos>270 && xPos<348 && yPos>112 && yPos<196) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
    collisionRoom2=true;
  } else if (xPos<300 && yPos>257 && yPos<327) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
    collisionRoom2=true;
  } else {
    xPosPrev=xPos;
    yPosPrev=yPos;
  }
}

void room2Complete() {
  println("Congradulations!");
  background(0);
  xPos=400;
  yPos=430;
  xPosPrev=400;
  yPosPrev=430;
  roomIndex=1;
  timer=1;
  textAlign(CENTER);
}

void room3() {
  background(rooms[6]);
  //intro message
  if (enteredRoom3==false) {
    if (keyPressed==false || timer<60) {
      xPos=600;
      yPos=250;
      fill(0);
      rectMode(CORNERS);
      noStroke();
      rect(200, 200, 570, 300);
      fill(255);
      textAlign(CENTER);
      text("The paths in this room contains boulders! You are only able to break two of them with your mana. To finish this level, both you and the key must be near the locked door at the end of the room.", 200, 200, 600, 300);
    }
  }
  if (keyPressed==true && timer>60) {
    enteredRoom3=true;
  }
  //breakable Barrier related
  strokeWeight(1);
  stroke(238, 213, 183);
  if (barrier1Destroyed==false) {
    for (int x=0; x<=43; x++) {
      line(510+x, 50, 510+x, 95);
    }
    if (xPos>500 && xPos<510+43 && yPos<95) {
      println("collision");
      xPos=xPosPrev;
      yPos=yPosPrev;
    }
  }
  if (barrier2Destroyed==false) {
    for (int x=0; x<=43; x++) {
      line(351+x, 50, 351+x, 95);
    }
    if (xPos>341 && xPos<341+53 && yPos<95) {
      println("collision");
      xPos=xPosPrev;
      yPos=yPosPrev;
    }
  }
  if (barrier3Destroyed==false) {
    for (int x=0; x<=43; x++) {
      line(351+x, 120, 351+x, 166);
    }
    if (xPos>341 && xPos<341+53 && yPos>96 && yPos<166) {
      println("collision");
      xPos=xPosPrev;
      yPos=yPosPrev;
    }
  }
  //breaking the barriers
  if (mana>0) {
    if (barrier1Destroyed==false && xPos>480 && xPos<510+63 && yPos<105 &&(key=='q' || key=='Q')) {
      barrier1Destroyed=true;
      if (hasHammer==false) {
        mana-=300;
      }
    }
    if (barrier2Destroyed==false && xPos>321 && xPos<341+63 && yPos<105 &&(key=='q' || key=='Q')) {
      barrier2Destroyed=true;
      if (hasHammer==false) {
        mana-=300;
      }
    }
    if (barrier3Destroyed==false && xPos>320 && xPos<341+73 && yPos>90 && yPos<186 &&(key=='q' || key=='Q')) {
      barrier3Destroyed=true;
      if (hasHammer==false) {
        mana-=300;
      }
    }
  }
  //Key-related
  //  Placing the key
  if (getKey3==false) {
    image(items[0], 459, 58);
  }
  //  Activating the key
  if (mousePressed==true && dist(mouseX, mouseY, 459, 58)<50 && dist(xPos, yPos, 459, 58)<50) {//Is the mouse pressed and close to the key
    getKey3=true;
  }
  //  Moving the key with the mouse
  if (getKey3==true) {
    if (mousePressed==true) {
      keyX=mouseX;
      keyY=mouseY;
    }
    image(items[0], keyX, keyY);
  }
  //  Is the key at the door (with the player avatar)?
  if (xPos>160 && xPos<210 && yPos>200 && yPos<280 && keyX>160 && keyX<210 && keyY>200 && keyY<280) {
    room3Complete();
  }

  //Leaving the room
  if (xPos<693 && xPos>618 && yPos>175 && yPos<301 && (key=='Q'||key=='q')) { //if player is near the entrance and presses 'q'
    roomIndex=1;
    xPos=230;
    yPos=240;
    xPosPrev=230;
    yPosPrev=240;
  } 

  //collisions
  if (xPos<673 && xPos>638 && yPos>195 && yPos<281) { //entrance collision
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos>663 || xPos<177 || yPos<52 || yPos>420) { //outside wall collision
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } 
  //top right section
  else if (xPos>388 && xPos<510 && yPos<226 && yPos>76) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos>543 && xPos<604 && yPos<226) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos>388 && xPos<412 && yPos<256 && yPos>76) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos>282 && xPos<411 && yPos>231 && yPos<301) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos>327 && xPos<355 && yPos>301 && yPos<335) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos>327 && xPos<411 && yPos>325 && yPos<394) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } 
  //the '4' shape at the start of the maze
  else if (xPos>544 && xPos<603 && yPos>250) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos>500 && xPos<563 && yPos>313 && yPos<395) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos<290 && yPos>324) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } 
  //left section
  else if (xPos>447 && xPos<506 && yPos>250 && yPos<395) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos<207 && yPos>250) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos>213 && xPos<243 && yPos>73 && yPos<300) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos>233 && xPos<351 && yPos>143 && yPos<208) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos>279 && xPos<351 && yPos<120) {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else {
    xPosPrev=xPos;
    yPosPrev=yPos;
  }
}

void room3Complete() {
  println("Congradulations!");
  background(0);
  xPos=230;
  yPos=240;
  xPosPrev=230;
  yPosPrev=240;
  roomIndex=1;
  textAlign(CENTER);
}

void room4() {
  background(rooms[7]);
  //lighting up the room
  if (keyPressed==true && enteredRoom4==true) {
    if ((key=='q'||key=='Q')&& mana!=0) {
      background(rooms[8]);
      mana-=2;
    }
  }

  //intro message
  if (enteredRoom4==false) {
    if (keyPressed==false || timer<60) {
      xPos=600;
      yPos=250;
      fill(50);
      rectMode(CORNERS);
      noStroke();
      rect(200, 200, 570, 300);
      fill(255);
      textAlign(CENTER);
      text("This room is completely dark! You can press 'Q' to light the room, at the cost of your mana. To finish this level, both you and the key must be near the locked door at the end of the room. There is also another object in this level that may help you in another level.", 200, 200, 600, 300);
    }
  }
  if (keyPressed==true && timer>60) {
    enteredRoom4=true;
  }
  //Hammer-related
  //  Placing the hammer
  if (hasHammer==false) {
    image(items[1], 339, 163);
  }
  //  Collecting the hammer
  if (mousePressed==true && dist(mouseX, mouseY, 339, 163)<50&&dist(xPos, yPos, 339, 163)<50) {//Is the mouse pressed and close to the hammer
    hasHammer=true;
  }

  //Key-related
  //  Placing the key
  if (getKey4==false) {
    image(items[0], 206, 334);
  }
  //  Activating the key
  if (mousePressed==true && dist(mouseX, mouseY, 206, 334)<50&&dist(xPos, yPos, 206, 334)<50) {//Is the mouse pressed and close to the key
    getKey4=true;
  }
  //  Moving the key with the mouse
  if (getKey4==true) {
    if (mousePressed==true) {
      keyX=mouseX;
      keyY=mouseY;
    }
    image(items[0], keyX, keyY);
  }
  //  Is the key at the door (with the player avatar)?
  if (xPos>160 && xPos<210 && yPos>200 && yPos<280 && keyX>160 && keyX<210 && keyY>200 && keyY<280) {
    room4Complete();
  }

  //Leaving the room
  if (xPos<693 && xPos>618 && yPos>175 && yPos<301 && (key=='Q'||key=='q')) { //if player is near the entrance and presses 'q'
    roomIndex=1;
    xPos=400;
    yPos=80;
    xPosPrev=400;
    yPosPrev=80;
  } 
  //collisions
  if (xPos<673 && xPos>638 && yPos>195 && yPos<281) { //entrance collision
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } else if (xPos>663 || xPos<177 || yPos<94 || yPos>382) { //room wall collision
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  } 
  //entrance 
  else if (xPos>600 && xPos<663 && yPos>94 && yPos<382) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } else if (xPos>555 && yPos>232 && yPos<247) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } else if (xPos>517 && xPos<558 && yPos>158) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } 
  //bottom path
  else if (xPos>397 && xPos<558 && yPos>364) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } else if (xPos>447 && xPos<480 && yPos>264 && yPos<368) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } else if (xPos>380 && xPos<480 && yPos>260 && yPos<280) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } else if (xPos>380 && xPos<414 && yPos>154 && yPos<280) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } else if (xPos>316 && xPos<414 && yPos>154 && yPos<176) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } 
  //top path
  else if (xPos>447 && xPos<553 && yPos>156 && yPos<176) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } else if (xPos>447 && xPos<486 && yPos<176) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } else if (xPos>253 && xPos<557 && yPos<113) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } else if (xPos>253 && xPos<288 && yPos<230) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } else if (xPos>207 && xPos<255 && yPos>148 && yPos<170) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } else if (yPos>213 && yPos<237 && xPos<347) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } else if (xPos>303 && xPos<350 && yPos>222) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } else if (xPos<310 && yPos>358) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } else if (xPos<215 && yPos>305) {
    xPosPrev=xPos;
    yPosPrev=yPos;
  } else {
    println("collision");
    xPos=xPosPrev;
    yPos=yPosPrev;
  }
}

void room4Complete() {
  println("Congradulations!");
  background(0);
  xPos=400;
  yPos=80;
  xPosPrev=400;
  yPosPrev=80;
  roomIndex=1;
  textAlign(CENTER);
}

void exitScreen() {
  background(0);
  textSize(25);
  fill(255);
  if (getKey1==true && getKey2==true && getKey3==true&&getKey4==true) {
    text ("Congradulations! You have escaped!", 400, 100);
  } else if (countdown<0) {
    text ("You have failed to escape!", 400, 100);
  }
  text("This program was made by Nathan Lu. I hope you enjoyed it!", 400, 250);
  frameRate(0);
}


// Main functions
//  Void setup() is for one time use commands only, such as setting size and importing pictures
void setup() {
  size (800, 500);
  playerStanding [0] = loadImage("Male Standing Left.png");
  playerStanding [1] = loadImage("Male Standing Right.png");
  playerStanding [2] = loadImage("Male Casting.png");
  playerStanding [3] = loadImage("Female Standing Left.png");
  playerStanding [4] = loadImage("Female Standing Right.png");
  playerStanding [5] = loadImage("Female Casting.png");
  playerWalking [0] = loadImage("Walking 1.png");
  playerWalking [1] = loadImage("Walking 2.png");
  playerDash = loadImage("Running Animation");
  rooms[0] = loadImage("Starting Room.jpg");
  rooms[1] = loadImage("Lobby.jpg");
  rooms[2] = loadImage("Room 1 Form 1.jpg");
  rooms[3] = loadImage("Room 1 Form 2.jpg");
  rooms[4] = loadImage("Room 1 Form 3.jpg");
  rooms[5] = loadImage("Room 2.jpg");
  rooms[6] = loadImage("Room 3.jpg");
  rooms[7] = loadImage("Room 4.jpg");
  rooms[8] = loadImage("Room 4 with Lights.jpg");
  items [0] = loadImage("Key.png");
  items [1] = loadImage("Hammer.png");
}

//  void draw() is for the recurring parts of the program.
void draw() {
  if (programState=='1') {
    instructions();
  } else if (programState=='2') {
    instructions();
  } else if (programState=='3') {
    backstory();
  } else if (programState=='4') {
    chooseCharacter();
  } else if (programState=='5') {
    exitScreen();
  } else if (programState=='6') {
    if (roomIndex==0) {
      startingRoom();
    } else if (roomIndex==1) {
      lobby();
    } else if (roomIndex==2 || roomIndex==3 || roomIndex==4) {
      if (enteredRoom1==false) {
        xPos=600;
        yPos=250;
        keyX=600;
        keyY=250;
      }
      room1();
    } else if (roomIndex==5) {
      room2();
    } else if (roomIndex==6) {
      print("test");
      room3();
    } else if (roomIndex==7) {
      room4();
    }
    userInput();
    display();
    countdown--;
  } else if (programState=='0') {
    mainMenu();
  } else {
    splashScreen();
  }
  timer++;
  print(xPos + " " + yPos + "\n");
  println("timer " + timer);
  println("mouse " + mouseX + " " + mouseY);
  println("timer " + countdown);
}
