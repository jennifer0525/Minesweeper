/* 
1. Review else-statement of mousepressed()
2. Review 2nd argument of countmines()
3. Reveal all the mines after the player looses (in red)
4. Reveal all the mines after the player wins (in green)
5. Using Keypressed(), increase or decrease the difficulty level with a limit
   on how big or how small the grid is
*/


import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private final static int NUM_ROWS = 10;
private final static int NUM_COLS = 10;  
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);
  // mines = new ArrayList <MSButton>();

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++)
      buttons [r][c] = new MSButton(r, c);
  }

  setMines();
}
public void setMines()
{
    // your code here: step 9
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    
    /* Use the contains() function to check to see if the button at that random row 
    and col is already in mines. If it isn't then add it*/
    
    /*for loop is to help create multiple mines instead of just one and you have to
    reset row and col to a random variable in order for it to be in a different location
    use the i-- if there is a mine at the random spot because you still want the 
    same number of mines*/
    for (int i = 0; i < 15; i++){ 
      if (!mines.contains(buttons[row][col]) == true){
        mines.add(buttons[row][col]);
      } else {
        i--;
        row = (int)(Math.random()*NUM_ROWS);
        col = (int)(Math.random()*NUM_COLS);
        }
     }
}


public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
    //step 14
    for (int r = 0; r < NUM_ROWS; r++){
      for (int c = 0; c < NUM_COLS; c++){
        if (!buttons[r][c].clicked && !mines.contains(buttons[r][c]))
          return false;
      }
    }
    return true;
}
public void displayLosingMessage()
{
    buttons[1][1].myLabel= "Y";
    buttons[1][2].myLabel= "O";
    buttons[1][3].myLabel= "U";
    buttons[2][0].myLabel= "L";
    buttons[2][1].myLabel= "O";
    buttons[2][2].myLabel= "S";
    buttons[2][3].myLabel= "E";
    buttons[2][4].myLabel= "!";
    
}
public void displayWinningMessage()
{    
    fill(0,255,0);
    buttons[1][1].myLabel= "Y";
    buttons[1][2].myLabel= "O";
    buttons[1][3].myLabel= "U";
    buttons[2][1].myLabel= "W";
    buttons[2][2].myLabel= "I";
    buttons[2][3].myLabel= "N";
}

public boolean isValid(int r, int c) // step 11
{
    if (r >= 0 && c >= 0 && r < NUM_ROWS && c < NUM_COLS){
      return true;
    } 
    return false;
}

public int countMines(int row, int col)
{
  int numMines = 0;
  if (isValid(row-1, col) == true && mines.contains(buttons[row-1][col]))
    numMines++;
  if (isValid(row+1, col) == true && mines.contains(buttons[row+1][col]))
    numMines++;
  if (isValid(row, col-1) == true && mines.contains(buttons[row][col-1]))
    numMines++;
  if (isValid(row, col+1) == true && mines.contains(buttons[row][col+1]))
    numMines++;
  if (isValid(row-1, col+1) == true && mines.contains(buttons[row-1][col+1]))
    numMines++;
  if (isValid(row-1, col-1) == true && mines.contains(buttons[row-1][col-1]))
    numMines++;
  if (isValid(row+1, col+1) == true && mines.contains(buttons[row+1][col+1]))
    numMines++;
  if (isValid(row+1, col-1) == true && mines.contains(buttons[row+1][col-1]))
    numMines++;
  return numMines;
}

public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col;
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
 public void mousePressed () 
    {
        clicked = true;
        //step 13
        if (mouseButton == RIGHT){
          if (flagged == false){
            flagged = true;
          } else if (flagged == true){
             flagged = false;
             clicked = false;
            }
        } 
        else if(mines.contains(this)){
          displayLosingMessage();
          System.out.println("You Lose!");
        }
        else if(countMines(myRow,myCol) > 0){
          setLabel(countMines(myRow,myCol));
          System.out.println(countMines(myRow,myCol));
        }
        else{
          // for the upper limit, it's +1 and not +2 because you only want the boxes 
          // that are right above or next to clicked box, not the diagonal ones
          for(int r = myRow-1; r < myRow+1; r++){
            for(int c = myCol-1; c < myCol+1; c++){
              if(isValid(r,c) && buttons[r][c].clicked == false){
                buttons[r][c].mousePressed();
              }
            }
          }
        }
        
    }
    
  public void draw ()
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) )
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 ); 
    else
      fill( 100 ); 

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  
  public void setLabel(String newLabel){
    myLabel = newLabel;
  }
  
  public void setLabel(int newLabel){
    myLabel = ""+ newLabel;
  }
  
  public boolean isFlagged(){
    return flagged;
  }
  
