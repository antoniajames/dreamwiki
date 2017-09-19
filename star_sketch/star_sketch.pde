/*
 * Multiline Text Box
 * 
 * 2012 William Smith
 * aka calsign
 * 
 * Implementation requires mousePressed(), mouseDragged(),
 * mouseReleased(), and keyPressed() to call their respective
 * functions in the class. This class has been extracted from one of myf
 * ongoing projects and is in no way complete, although it features
 * numerous ideas that may be of use to beginners in this area.
 * 
 * Text box supports basic text input, multiple lines, lines returning when
 * becoming too long (TODO), selection, and copy + paste.
 */

import java.awt.event.KeyEvent;
 
 
MultilineTextBox textBox;
StringDict symbol_dict; //later, make this global
XML xml; // make this global
void setup() {

  size(640, 360);
  
  textBox = new MultilineTextBox("Type dream symbol here", 50, 50, 500, 500);
  background(0, 60, 60);
  textSize(32);

  // TEST IMAGE LOADING
  //PImage img;
  //img = loadImage("8ball.png");
  //imageMode(CORNER);
  //image(img, 10, 10, 200, 200);
  
  //INITIAL LOAD OF XML:
  
  xml = loadXML("dream_dict.xml");
  XML[] children = xml.getChildren("word");
  
  // HERE, we make an empty dictionary for storing terms. This is for
  // easy, fast search through terms compared to a search thru XML file:
  

  
  symbol_dict = new StringDict();
  
  for (int i = 0; i < children.length; i++) {
     // get the current term:
     String cur_term = children[i].getContent(); 
     // get its definition:
     String cur_def = children[i].getString("def");
     // save the term and definition into dictionary:
     symbol_dict.set(cur_term, cur_def);
  }
  

  //testing XML //
  for (int i = 0; i < children.length; i++) {
    String coloring = children[i].getString("def"); //gets dream definintion
    String word = children[i].getContent(); //gets the word
    
    //println(coloring + ", " + word);
    //text(word, 10, 30+(i*30)); 
    
  }
  
  
  
}

void draw() {
 
  //pushMatrix();
  //translate(width*0.8, height*0.5);
  //rotate(frameCount / -100.0);
  //star(0, 0, 30, 70, 5); 
  //popMatrix();
  
  textBox.update();
  textBox.display();
}



// HERE, we begin a search text field:
// the user can type into this field. pressing enter (or a button)
// search for the term in the GLOBAL symbols_dict (no capitals) 
// using hasKey.
// if nothing is found (hasKey = 0), we say "nothing found, want to create term?"
// if something is found (hasKey = 1), we display term, source,
// and option to edit term.


// later on in the project, try to implement a feature that takes 
// the text value and displays a list of search terms beginning with
// that letter. I would have to make a function for this, like 
// is_prefix(search_input, dicterm) and a function that does this for 
// all terms. probably can google this.
// also, we can just use a tree/trie for all the dictionary terms by putting
// all the keys into an array and creating a trie.
// ORRRR, we can always have the dictionary sorted, so we can go through all 
// the terms in the array until we find one with the term as the prefix (if we do)
// and we can check the terms afterwards, listing all the terms that have
// the term as a prefix.


void search_bar() {
  //MUST BE CALLED INSIDE DRAW
  
  
}

//void star(float x, float y, float radius1, float radius2, int npoints) {
//  float angle = TWO_PI / npoints;
//  float halfAngle = angle/2.0;
//  beginShape();
//  for (float a = 0; a < TWO_PI; a += angle) {
//    float sx = x + cos(a) * radius2;
//    float sy = y + sin(a) * radius2;
//    vertex(sx, sy);
//    sx = x + cos(a+halfAngle) * radius1;
//    sy = y + sin(a+halfAngle) * radius1;
//    vertex(sx, sy);
//  }
//  endShape(CLOSE);
//}

void mousePressed() {
  textBox.updatePress();
}
 
void mouseDragged() {
  textBox.updateDrag();
}
 
void mouseReleased() {
  textBox.updateRelease();
}
 
void keyPressed() {
  textBox.updateKeys();
}
 
class MultilineTextBox {
  String prompt;
  String[] text;
  int xpos;
  int ypos;
 
  boolean alreadyPressed;
  boolean selecting;
  int xpos2;
  int ypos2;
 
  PVector loc;
 
  float WIDTH;
  float HEIGHT;
 
  boolean inverseBackground;
  boolean hasFocus;
  boolean hasInputFocus;
 
  int lastPress = -500;
 
  MultilineTextBox(String prompt, float x, float y, float w, float h) {
    WIDTH = w;
    HEIGHT = h;
 
    this.prompt = prompt;
    text = new String[1];
    text[0] = "";
    ypos = 0;
    xpos = 0;
 
    loc = new PVector(x, y);
  }
 
  MultilineTextBox(String prompt, float x, float y, float w, float h, boolean inverseBackground) {
    WIDTH = w;
    HEIGHT = h;
 
    this.prompt = prompt;
    text = new String[1];
    text[0] = "";
    ypos = 0;
    xpos = 0;
 
    loc = new PVector(x, y);
 
    this.inverseBackground = inverseBackground;
  }
 
  void update() {
  }
 
  void updatePress() {
    if (mousePressed) {
      if (mouseX > loc.x && mouseX < loc.x + WIDTH && mouseY > loc.y && mouseY < loc.y + HEIGHT) {
        hasFocus = true;
        hasInputFocus = true;
 
        testPos();
 
        alreadyPressed = true;
      } 
      else {
        hasFocus = (text.length <= 1 && text[0].length() <= 0 ? false : true);
        hasInputFocus = false;
        if (!alreadyPressed) selecting = false;
      }
    }
  }
 
  void updateDrag() {
    if (mouseX > loc.x && mouseX < loc.x + WIDTH && mouseY > loc.y && mouseY < loc.y + HEIGHT) testPos();
    else if (selecting) testPos();
  }
 
  void updateRelease() {
    alreadyPressed = false;
  }
 
  void updateKeys() {
    if (keyPressed) {
      if (key == CODED) {
        if (millis() - lastPress > 0) {
          if (keyCode == LEFT) {
            if (xpos <= 0 && ypos > 0) {
              ypos --;
              xpos = text[ypos].length();
            } 
            else xpos = constrain(xpos - 1, 0, text[ypos].length());
          }
          if (keyCode == RIGHT) {
            if (xpos >= text[ypos].length() && ypos < text.length - 1) {
              ypos ++;
              xpos = 0;
            } 
            else xpos = constrain(xpos + 1, 0, text[ypos].length());
          }
          if (keyCode == UP && ypos > 0) {
            ypos --;
            xpos = constrain(xpos, 0, text[ypos].length());
          }
          if (keyCode == DOWN && ypos < text.length - 1) {
            ypos ++;
            xpos = constrain(xpos, 0, text[ypos].length());
          }
          if (keyCode == KeyEvent.VK_HOME) xpos = 0;
          if (keyCode == KeyEvent.VK_END) xpos = text[ypos].length();
 
          if (!(keyCode == SHIFT)) {
            ypos2 = ypos;
            xpos2 = xpos;
          }
 
          lastPress = millis();
        }
      } 
      else {
        switch(key) {
        case ESC:
        case TAB:
          break;
        case ENTER:
          key = RETURN;
        case RETURN:
          XML newChild = xml.addChild("word");
          newChild.setContent("test");
          newChild.setString("word", "TEST PASSED");
          saveXML(xml, "dream_dict.xml");
          //newline();
          search_term();
          break;
        case BACKSPACE:
        case DELETE:
          if (selecting && (ypos != ypos2 || xpos != xpos2)) {
            int minypos = min(ypos, ypos2);
            int maxypos = max(ypos, ypos2);
 
            int minxpos;
            int maxxpos;
 
            if (minypos == maxypos) {
              minxpos = min(xpos, xpos2);
              maxxpos = max(xpos, xpos2);
            } 
            else {
              minxpos = (minypos == ypos ? xpos : xpos2);
              maxxpos = (maxypos == ypos ? xpos : xpos2);
            }
 
            if (minypos == maxypos) text[ypos] = text[ypos].substring(0, minxpos) + text[ypos].substring(maxxpos, text[ypos].length());
            else {
              String combine = text[minypos].substring(0, minxpos) + text[maxypos].substring(maxxpos, text[maxypos].length());
              String[] pre = append(subset(text, 0, minypos), combine);
              text = concat(pre, subset(text, maxypos + 1, text.length - (maxypos + 1)));
            }
 
            ypos = minypos;
            xpos = minxpos;
 
            ypos2 = ypos;
            xpos2 = xpos;
            selecting = false;
 
            lastPress = millis();
          } 
          else {
            if (millis() - lastPress > 0 && xpos > 0) {
              text[ypos] = text[ypos].substring(0, xpos - 1) + text[ypos].substring(xpos, text[ypos].length());
 
              xpos --;
              xpos2 = xpos;
 
              lastPress = millis();
            } 
            else if (ypos > 0 && xpos == 0) {
              int over = text[ypos - 1].length();
              String combine = text[ypos - 1] + text[ypos];
 
              String[] pre = append(subset(text, 0, ypos - 1), combine);
              text = concat(pre, subset(text, ypos + 1, text.length - (ypos + 1)));
 
              ypos --;
              xpos = over;
 
              ypos2 = ypos;
              xpos2 = xpos;
            }
          }
          break;
        default:
          if (selecting && (ypos != ypos2 || xpos != xpos2)) {
            int minypos = min(ypos, ypos2);
            int maxypos = max(ypos, ypos2);
 
            int minxpos;
            int maxxpos;
 
            if (minypos == maxypos) {
              minxpos = min(xpos, xpos2);
              maxxpos = max(xpos, xpos2);
            } 
            else {
              minxpos = (minypos == ypos ? xpos : xpos2);
              maxxpos = (maxypos == ypos ? xpos : xpos2);
            }
 
            if (millis() - lastPress > 0) {
 
              if (minypos == maxypos) text[ypos] = text[ypos].substring(0, minxpos) + key + text[ypos].substring(maxxpos, text[ypos].length());
              else {
                String combine = text[minypos].substring(0, minxpos) + key + text[maxypos].substring(maxxpos, text[maxypos].length());
                String[] pre = append(subset(text, 0, minypos), combine);
                text = concat(pre, subset(text, maxypos + 1, text.length - (maxypos + 1)));
              }
 
              ypos = minypos;
              xpos = minxpos + 1;
 
              ypos2 = ypos;
              xpos2 = xpos;
              selecting = false;
 
              lastPress = millis();
            }
          } 
          else {
            if (millis() - lastPress > 0 && textWidth(text[ypos].substring(0, xpos) + key + text[ypos].substring(xpos, text[ypos].length())) < WIDTH - 8) {
              text[ypos] = text[ypos].substring(0, xpos) + key + text[ypos].substring(xpos, text[ypos].length());
 
              xpos ++;
              xpos2 = xpos;
 
              lastPress = millis();
            }
          }
          break;
        }
      }
    }
  }
  
  void search_term() {

     String term = join(text, "");
     if (symbol_dict.hasKey(term.toLowerCase()))
     {
       println("YES " + term);
       text = new String[1];
       text[0] = "";
       ypos = 0;
       xpos = 0;
     } 
     else {
       println(term + " was not found. create it?"); 
     }
  }
 
  //void newline() {
  //  String after = text[ypos].substring(xpos, text[ypos].length());
  //  text[ypos] = text[ypos].substring(0, xpos);
  //  text = splice(text, after, ypos + 1);
 
  //  ypos ++;
  //  xpos = 0;
 
  //  ypos2 = ypos;
  //  xpos2 = xpos;
  //}
 
  void testPos() {
    if (alreadyPressed) {
      selecting = true;
 
      ypos2 = int(constrain((mouseY - loc.y) / 12.0, 0, text.length - 1));
 
      for (int i = 0; i < text[ypos2].length(); i ++) {
        if (mouseX - loc.x - 4 <= textWidth(text[ypos2].substring(0, i)) + textWidth(text[ypos2].charAt(i)) / 2) {
          xpos2 = i;
          return;
        }
      }
 
      xpos2 = text[ypos].length();
    } 
    else {
      selecting = false;
 
      ypos = int(constrain((mouseY - loc.y) / 12.0, 0, text.length - 1));
 
      for (int i = 0; i < text[ypos].length(); i ++) {
        if (mouseX - loc.x - 4 <= textWidth(text[ypos].substring(0, i)) + textWidth(text[ypos].charAt(i)) / 2) {
          xpos = i;
          return;
        }
      }
 
      xpos = text[ypos].length();
    }
  }
 
  void display() {
    if (inverseBackground) fill(0);
    else fill(255, 250, 250);
    stroke(0);
    //if (hasInputFocus) strokeWeight(2);
    //else strokeWeight(1);
    strokeWeight(0);
    rectMode(CORNER);
 
    rect(loc.x, loc.y, WIDTH, HEIGHT);
 
    int textSize = 40;
 
    textSize(textSize);
    textAlign(LEFT, TOP);
    if (hasFocus) fill(0);
    else fill(102);
 
    if (hasFocus) {
      for (int i = 0; i < text.length; i ++)
        text(text[i], loc.x + 4, loc.y + 2 + i * 12);
    } 
    else text(prompt, loc.x + 4, loc.y + 2);
 
    ypos = constrain(ypos, 0, text.length);
    ypos2 = constrain(ypos2, 0, text.length);
 
    xpos = constrain(xpos, 0, text[ypos].length());
    xpos2 = constrain(xpos2, 0, text[ypos2].length());
 
 // SELECTING
 
    if (selecting && (xpos != xpos2 || ypos != ypos2)) {
      fill(255, 100, 100, 102);
      noStroke();
 
      int minypos = min(ypos, ypos2);
      int maxypos = max(ypos, ypos2);
 
      int minxpos;
      int maxxpos;
 
      if (minypos == maxypos) {
        minxpos = min(xpos, xpos2);
        maxxpos = max(xpos, xpos2);
      } 
      else {
        minxpos = (minypos == ypos ? xpos : xpos2);
        maxxpos = (maxypos == ypos ? xpos : xpos2);
      }
 
      // SELECTING
      
      if (minypos == maxypos) rect(loc.x + 4 + textWidth(text[minypos].substring(0, minxpos)), loc.y + 4 + minypos * 12, textWidth(text[maxypos].substring(0, maxxpos)) - textWidth(text[maxypos].substring(0, minxpos)), textSize);
      else {
        for (int y = minypos; y <= maxypos; y ++) {
          for (int x = 0; x < text[y].length(); x ++) {
            if ((y == minypos ? x >= minxpos : true) && (y == maxypos ? x < maxxpos : true)) rect(loc.x + 4 + textWidth(text[y].substring(0, x)), loc.y + 4 + y * textSize, textWidth(text[y].charAt(x)), 12);
          }
          if (text[y].length() <= 0) rect(loc.x + 4, loc.y + 4 + y * textSize, textWidth(" ") / 2, textSize);
        }
      }
    } 
    
    // TYPING BLINKER:
    else if (hasInputFocus && millis() / 300 % 2 == 1) line(loc.x + 4 + textWidth(text[ypos].substring(0, xpos)), loc.y + 4 + ypos * 12, (loc.x + 4 + textWidth(text[ypos].substring(0, xpos))), loc.y + textSize+4 + ypos * 12);
  }
 
  String[] getText() {
    return text;
  }
 
  void setText(String toSet) {
    String[] output = new String[0];
    int last = -1;
    for (int i = 0; i < toSet.length(); i ++) {
      if (toSet.charAt(i) == '\n') {
        output = append(output, toSet.substring(last + 1, i));
        last = i;
      }
    }
 
    output = append(output, toSet.substring(last + 1, toSet.length()));
 
    text = output;
  }
 
  String consolidate() {
    String toReturn = "";
    for (int i = 0; i < text.length; i ++) {
      toReturn += text[i];
      if (i < text.length - 1) toReturn += "\n";
    }
 
    return toReturn;
  }
}
