# FINAL PROJECT - SPACE ATTACK

  ## GOAL
    Our goal in this project is to create a full game from scratch using either LÖVE or Unity.
  ## SPECIFICATION
   ### 1. Your game must be in either LÖVE or Unity.
     The game is, indeed, developed using lua and LÖVE2D.
   ### 2. Your game must be a cohesive start-to-finish experience for the user.
     As requested, our game counts with a TitleScreen, a playing experience and a final screen before allowing the user to start over.
   ### 3. Your game should have at least three GameStates to separate the flow of your game’s user experience.
     Like we have just explained, the game has a TitleState, a PlayState and a ScoreState, although it has many more making it a richer game experience
   ### 4. Your game can be most any genre you’d like
     It is a 2D space shooter, space invaders-like, where the goal is to score indefinitely so that you beat the other scores
   ### 5. You are allowed to use libraries and assets in either game development environment, but the bulk of your game’s logic must be handwritten
     I have used the push and the Class libraries as well as assets that I have found in the Internet but the game logic is handwritten and can be seen in the
     files
  ## THE GAME
    Space Attack is a 2D space shooter game based on Space Invaders. The game counts with a main screen that allows the player to do several things. From here, the
    player is able to navigate to two other screens: the "HighScores" screen, where he can see the highest scores recorded on the game and the "How to Play"
    screen, where he will learn how to play the game. Most importantly, the player can choose "Play", which will start the game. Once this happens, there will be a 
    countdown and after that, the game will be shown. The user will be able to move the player's ship in every direction and to shoot lasers trying to defeat the 
    enemies while also dodging their lasers and collecting diferent power-ups. Every so often, the player will encounter a thrilling boss fight with a giant ship, 
    and as long as he keeps defeating them, the game's difficulty will rise, spawning more enemies that shoot more lasers and giving the bosses more health. The 
    player will keep scoring indefinitely until he dies.
    
    The goal is to try to survive and score the maximum amount of points that you can to beat your friends!
    
    I believe this project is more complex and distinct from some of the games that we have implemented this course. This is due to the fact that it takes a 
    portion from all of them (at least the LOVE2D ones). For starters, we do use a big StateMachine that counts with several states which is something that we
    have seen throughout the whole course. For example, the project counts with particle systems, different sounds, an animation (the boss ship is animated) and
    the infinite scrolling background. These are things I have learned in many different lectures and they do make the project a better game experience. Secondly,
    the regular alien ships move constantly in the X axis but an algorithm has been implemented (based on the zelda ones) to make them move randomly in the Y axis.
    Even though the boss ship does not move, it has another type of enemy shot that will deal extra damage to our player and there are transitions that will warn
    you when you will face the boss. Like in the Flappy Bird assignment, we can also pause the game in either the PlayState or the BossState. We keep track of the
    number of bosses the player has defeated so that we can keep making the game harder and harder evey time, increasing different rates and stats. This is 
    different from any other project in the course, since they all had a constant difficulty (i.e. the pipes in FlappyBird did not have smaller and smaller gaps or
    Mario did not have harder levels). We also have different powerups that help the player get through the enemies when he picks them up. These are some of the
    reasons that lead me to believe that my project is of high enough complexity for the course
    
  ## CREDITS
    1. Sound found in https://freesound.org as well as other CS50g assignments
    2. Images, particles and such found in https://opengameart.org as well as other CS50g assignments
    3. The Space Invaders font was dowloaded from https://www.dafontfree.net
  
  ## DEMO
    https://youtu.be/gpo8COmFVuI
