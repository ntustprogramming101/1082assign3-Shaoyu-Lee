final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int START_BUTTON_W = 144;
final int START_BUTTON_H = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;

final int ONE_BLOCK = 80;
final int SUN_W = 120;
final int SUN_D = 50; //Distance from center to boundary

final int LIFE_W = 50;
final int LIFE_H = 50;
final int LIFE_D = 20; //Distance between life

final int GROUNDHOG_W = 80;
final int GROUNDHOG_H = 80;

PImage titleImg, gameoverImg, startNormalImg, startHoveredImg, restartNormalImg, restartHoveredImg;
PImage bgImg, soil8x24Img, soil0Img, soil1Img, soil2Img, soil3Img, soil4Img, soil5Img, stone1Img, stone2Img;
PImage lifeImg ;
PImage groundhogIdleImg, groundhogDownImg, groundhogLeftImg, groundhogRightImg;

float groundhogX, groundhogY;
float groundhogLestX, groundhogLestY;

int groundhogMoveTime = 250;
int actionFrame; //groundhog's moving frame 
int scrollFrame;
int floor;
float lastTime; //time when the groundhog finished moving

boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

// For debug function; DO NOT edit or remove this!
int playerHealth = 2;
int playerHealthX, playerHealthY = 10;
float offsetY = 0, offsetLestY;
float soilY;
float cameraOffsetY = 0;
boolean debugMode = false;
boolean soilScrolling = false;

void setup() {
  size(640, 480, P2D);
  // Enter your setup code here (please put loadImage() here or your game will lag like crazy)
  bgImg = loadImage("img/bg.jpg");
  titleImg = loadImage("img/title.jpg");
  gameoverImg = loadImage("img/gameover.jpg");
  startNormalImg = loadImage("img/startNormal.png");
  startHoveredImg = loadImage("img/startHovered.png");
  restartNormalImg = loadImage("img/restartNormal.png");
  restartHoveredImg = loadImage("img/restartHovered.png");
  soil8x24Img = loadImage("img/soil8x24.png");
  groundhogIdleImg = loadImage("img/groundhogIdle.png");
  groundhogDownImg = loadImage("img/groundhogDown.png");
  groundhogLeftImg = loadImage("img/groundhogLeft.png");
  groundhogRightImg = loadImage("img/groundhogRight.png");
  lifeImg = loadImage("img/life.png");
  soil0Img = loadImage("img/soil0.png");
  soil1Img = loadImage("img/soil1.png");
  soil2Img = loadImage("img/soil2.png");
  soil3Img = loadImage("img/soil3.png");
  soil4Img = loadImage("img/soil4.png");
  soil5Img = loadImage("img/soil5.png");
  stone1Img = loadImage("img/stone1.png");
  stone2Img = loadImage("img/stone2.png");

  groundhogX = ONE_BLOCK*4;
  groundhogY = ONE_BLOCK;
  frameRate(60);
  lastTime = millis(); // save lastest time call the millis();
  floor = 0;
}

void draw() {
  /* ------ Debug Function ------ 
   
   Please DO NOT edit the code here.
   It's for reviewing other requirements when you fail to complete the camera moving requirement.
   
   */
  if (debugMode) {
    pushMatrix();
    translate(0, cameraOffsetY);
  }
  /* ------ End of Debug Function ------ */


  switch (gameState) {

  case GAME_START: // Start Screen
    cameraOffsetY = 0;
    offsetLestY = 80;
    image(titleImg, 0, 0);

    if (START_BUTTON_X + START_BUTTON_W > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_H > mouseY
      && START_BUTTON_Y < mouseY) {

      image(startHoveredImg, START_BUTTON_X, START_BUTTON_Y);
      if (mousePressed) {
        gameState = GAME_RUN;
        mousePressed = false;
      }
    } else {

      image(startNormalImg, START_BUTTON_X, START_BUTTON_Y);
    }
    downPressed = false; 
    leftPressed = false;
    rightPressed = false;
    soilScrolling = false;
    break;

  case GAME_RUN: // In-Game

    // Background
    image(bgImg, 0, 0);

    // Sun
    stroke(255, 255, 0);
    strokeWeight(5);
    fill(253, 184, 19);
    ellipse(590, 50, 120, 120);

    if (soilScrolling) {
      pushMatrix();

      if (floor <= 20) {
        //offsetY = offsetLestY - ONE_BLOCK;
        scrollFrame++;
        if (scrollFrame > 0 && scrollFrame < 15) {
          offsetY -= ONE_BLOCK / 15.0;
          leftPressed = false;
          rightPressed = false;
        } else {
          offsetY = offsetLestY - ONE_BLOCK;
        }
      } else {
        offsetY = -1600;
      }
      translate(0, offsetY);
    }
    // Grass
    fill(124, 204, 25);
    noStroke();
    rect(0, 160 - GRASS_HEIGHT, width, GRASS_HEIGHT);

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 24; j ++) {
        int x = ONE_BLOCK * i;
        soilY = ONE_BLOCK * (j+2);
        if (j < 4) {
          image(soil0Img, x, soilY);
        }
        if (j >= 4 && j < 8) {
          image(soil1Img, x, soilY);
        }
        if (j >= 8 && j < 12) {
          image(soil2Img, x, soilY);
        }
        if (j >= 12 && j < 16) {
          image(soil3Img, x, soilY);
        }
        if (j >= 16 && j < 20) {
          image(soil4Img, x, soilY);
        }
        if (j >= 20 && j < 24) {
          image(soil5Img, x, soilY);
        }
      }
    }
    int stone1X, stone1Y;
    for (int i = 0; i < 8; i++ ) {
      stone1X = ONE_BLOCK * i;
      stone1Y = ONE_BLOCK * (i+2);
      image(stone1Img, stone1X, stone1Y);
      stone1Y = stone1Y + ONE_BLOCK;
    }
    for (int i = 0; i < 8; i++) {
      for (int j = 8; j < 16; j++) {
        stone1X = ONE_BLOCK * i;
        stone1Y = ONE_BLOCK * (j+2);
        if (i % 4 == 1 | i % 4 == 2 ) {
          if (j % 4 == 0 | j % 4 == 3 ) {
            image(stone1Img, stone1X, stone1Y);
          }
        }
        if (i % 4 == 0 | i % 4 == 3 ) { 
          if (j % 4 == 1 | j % 4 == 2) {
            image(stone1Img, stone1X, stone1Y);
          }
        }
      }
    }
    for (int i = 0; i < 8; i++ ) {
      for (int j = 16; j < 24; j++) {
        stone1X = ONE_BLOCK * i;
        stone1Y = ONE_BLOCK * (j+2);
        if (i % 3 == 0) {
          if (j % 3 == 0 | j % 3 == 2) {
            image(stone1Img, stone1X, stone1Y);
          }
          if (j % 3 == 0 ) {
            image(stone2Img, stone1X, stone1Y);
          }
        }
        if (i % 3 == 1) {
          if (j % 3 == 1 | j % 3 == 2) {
            image(stone1Img, stone1X, stone1Y);
          }
          if (j % 3 == 2) {
            image(stone2Img, stone1X, stone1Y);
          }
        }
        if (i % 3 == 2) {
          if (j % 3 == 1 | j % 3 == 0) {
            image(stone1Img, stone1X, stone1Y);
          }
          if (j % 3 == 1) {
            image(stone2Img, stone1X, stone1Y);
          }
        }
      }
    }

    if (soilScrolling) {
      popMatrix();
      if (floor <= 20) {
        //offsetY = offsetLestY - ONE_BLOCK;
        if (scrollFrame > 0 && scrollFrame < 15) {
          image(groundhogDownImg, groundhogX, groundhogY, GROUNDHOG_W, GROUNDHOG_H);
          leftPressed = false;
          rightPressed = false;
        } else {
          downPressed = false;
        }
      }
      println(offsetLestY, offsetY, floor);
    }

    //When the button is not pressed, draw the groundhogIdle image
    if (downPressed == false && leftPressed == false && rightPressed == false) {
      image(groundhogIdleImg, groundhogX, groundhogY, GROUNDHOG_W, GROUNDHOG_H);
    }
    //draw the groundhogDown image between 1-14 frames
    if (downPressed) {
      actionFrame++;
      if (floor > 20) {
        if (actionFrame > 0 && actionFrame < 15) {
          groundhogY += ONE_BLOCK / 15.0;
          image(groundhogDownImg, groundhogX, groundhogY, GROUNDHOG_W, GROUNDHOG_H);
        } else {
          groundhogY = groundhogLestY + ONE_BLOCK;
          downPressed = false;
        }
      }
    }
    //draw the groundhogLeft image between 1-14 frames
    if (leftPressed) {
      downPressed = false;
      actionFrame++;
      if (actionFrame > 0 && actionFrame < 15) {
        groundhogX -= ONE_BLOCK / 15.0;
        image(groundhogLeftImg, groundhogX, groundhogY, GROUNDHOG_W, GROUNDHOG_H);
      } else {
        groundhogX = groundhogLestX - ONE_BLOCK;
        leftPressed = false;
      }
    }
    //draw the groundhogRight image between 1-14 frames
    if (rightPressed) {
      downPressed = false;
      actionFrame++;
      if (actionFrame > 0 && actionFrame < 15) {
        groundhogX += ONE_BLOCK / 15.0;
        image(groundhogRightImg, groundhogX, groundhogY, GROUNDHOG_W, GROUNDHOG_H);
      } else {
        groundhogX = groundhogLestX + ONE_BLOCK;
        rightPressed = false;
      }
    }

    //groundhog: boundary detection
    if (groundhogX >= width - ONE_BLOCK) {
      groundhogX = width - ONE_BLOCK;
    }
    if (groundhogX <= 0) {
      groundhogX = 0;
    }
    if (groundhogY >= height - ONE_BLOCK) {
      groundhogY = height - ONE_BLOCK;
    }
    if (groundhogY <= 0) {
      groundhogY = 0;
    }

    // Health UI
    for (int i = playerHealth; i >= 0; i--) {
      if (playerHealth == 0) {
        gameState = GAME_OVER;
      }
      if ( playerHealth > 0 && playerHealth <= 5) {
        playerHealthX = 10 + (LIFE_D+LIFE_W) * (i-1);
        image(lifeImg, playerHealthX, playerHealthY, LIFE_W, LIFE_H);
      }
    }
    break;

  case GAME_OVER: // Gameover Screen
    cameraOffsetY = 0;
    offsetLestY = 80;
    image(gameoverImg, 0, 0);

    if (START_BUTTON_X + START_BUTTON_W > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_H > mouseY
      && START_BUTTON_Y < mouseY) {

      image(restartHoveredImg, START_BUTTON_X, START_BUTTON_Y);
      if (mousePressed) {
        downPressed =false;
        leftPressed = false;
        rightPressed = false;
        playerHealth = 2;
        groundhogX = ONE_BLOCK*4;
        groundhogY = ONE_BLOCK;
        gameState = GAME_RUN; 
        mousePressed = false;
        // Remember to initialize the game here!
      }
    } else {
      image(restartNormalImg, START_BUTTON_X, START_BUTTON_Y);
    }
    break;
  }

  // DO NOT REMOVE OR EDIT THE FOLLOWING 3 LINES
  if (debugMode) {
    popMatrix();
  }
}

void keyPressed() {
  // Add your moving input code here
  float newTime = millis(); //time when the groundhog started moving
  if (key == CODED) {
    switch (keyCode) {
    case DOWN:
      if (newTime - lastTime > 250) {
        soilScrolling = true;
        scrollFrame = 0;
        downPressed = true;
        rightPressed = false;
        leftPressed = false;
        actionFrame = 0;
        floor++;
        groundhogLestY = groundhogY;
        offsetLestY = offsetY;
        lastTime = newTime;
      }
      if (scrollFrame > 15) {
        scrollFrame = 0;
      }
      break;
    case LEFT:
      if (newTime - lastTime > 250) {
        leftPressed = true;
        downPressed = false;
        rightPressed = false;
        actionFrame = 0;
        groundhogLestX = groundhogX;
        lastTime = newTime;
      }
      break;
    case RIGHT:
      if (newTime - lastTime > 250) {
        rightPressed = true;
        downPressed = false;
        leftPressed = false;
        actionFrame = 0;
        groundhogLestX = groundhogX;
        lastTime = newTime;
      }
      break;
    }
  }
  // DO NOT REMOVE OR EDIT THE FOLLOWING SWITCH/CASES
  switch(key) {
  case 'w':
    debugMode = true;
    cameraOffsetY += 25;
    break;

  case 's':
    debugMode = true;
    cameraOffsetY -= 25;
    break;

  case 'a':
    if (playerHealth > 0) playerHealth --;
    break;

  case 'd':
    if (playerHealth < 5) playerHealth ++;
    break;
  }
}

void keyReleased() {
}
