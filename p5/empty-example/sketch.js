var input, defInput, create, defInput, button, greeting;

var stars = [];  // array of Stars
var img;
var ddict;
var message = "";
var term = "";


function preload() {
  // CAN USE  JSON
  ddict = new Object();
  ddict["water"] = "related dreams can mean you feel overwhelmed or unsupported by your loved ones.";
  ddict["teeth falling out"] = "is all about your power and usually means you’re feeling subconsciously repressed or controlled.";
  ddict["falling"] = "is a dream symbol that means you’re thinking about letting go of something you’ve been holding onto for a while now.";
  ddict["snake"] = "can have good and bad meanings, but mostly they depend on the color.This is a complex dream meaning.";

  img = loadImage("https://i.imgur.com/FDLRQUb.png?1");
}

function setup() {
  //ddict.createStringDict(String, String);
  // create canvas
  createCanvas(windowWidth, windowHeight);
  background(0);

  for (var i=0; i<100; i++) {
    stars.push(new Star());
  }


  input = createInput();
  input.position(windowWidth/2.5, windowHeight/2.5);

  button = createButton('>>');
  button.style("background-color", "#ffff99");
  button.position(input.x + input.width + 10, input.y-2);


  button.mousePressed(search);
  
  
}

function draw() {
  var bgcolor = 50;
  background(bgcolor);
  image(img, input.x, input.y-50);
  mapStars();
  textFont("Helvetica Neue",20);
  textSize(20);
  fill(255, 255, (155+map(mouseX, 0, width, 0, 100)));
  //text(ddict["snake"], 50, 50);
  
  textStyle(ITALIC);
  textSize(20);
  text("enter a dream symbol:", input.x-20, input.y-65);
  if (message != "")
  {
    fill(bgcolor);
    noStroke();
    rect(0, input.y+90, windowWidth, windowHeight-input.y-90);
  }
  fill("yellow");
  textSize(16);
  text(message, 200, input.y + 100, 500, windowHeight-input.y-100);
}



function mapStars() {
  for (var i=0; i<stars.length; i++) {
    stars[i].move();
    stars[i].display();
  }
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);

  mapStars();
}

// Star Class 
function Star() {
  angleMode(DEGREES);
  this.angle = random(1, 360);
  
  this.size = random(1, 7);
  this.x0 = random(windowWidth);
  this.y0 = random(windowHeight);
  // THIS.size ? YES !
  this.z = map(this.size, 1, 7, 0, 100);
  this.x = this.x0 + map(mouseX, 0, windowWidth, -this.z, this.z);
  this.y = this.y0 + map(mouseY, 0, windowHeight, -this.z, this.z);
  this.alpha = 255;



  this.move = function() {
    this.x = this.x0 + map(mouseX, 0, windowWidth, -this.z, this.z);
    this.y = this.y0 + map(mouseY, 0, windowHeight, -this.z, this.z);
     
    this.size += .02;
    this.z = map(this.size, 1, 7, 0, 100);
    this.angle += 3;
    
    // when it is time for star to die:
    if (this.size > 7)
    {
      //this.die;
      if (this.alpha > 0)
      {
        this.alpha -= 75;
      }
      if (this.alpha <= 0)
      {
        this.alpha = 255;
        this.x = random(windowWidth) + map(mouseX, 0, windowWidth, -this.z, this.z);
        this.y = random(windowHeight) + map(mouseY, 0, windowHeight, -this.z, this.z);
        this.size = 0;
        this.z = map(this.size, 1, 7, 0, 100);
      }

    }

  }  

  this.display = function() {
    //fill(this.color);
    //noStroke(0);
    //ellipse(this.x, this.y, this.size, this.size);
    tint(255, this.alpha*map(this.size, 1, 7, .1, 1));
    push();
    
    translate(this.x, this.y);
    
    rotate(this.angle);
    
    image(img, 0, 0, (this.size+1)*3, (this.size+1)*3);
    pop();
  }

}

function search() {
  term = input.value();
  for (var key in ddict) {

    if (term.toLowerCase() == key)
    {
      message = key + ": " + ddict[key] + "\n(source: http://howtolucid.com/dream-interpretation/)";
    }
    else
    {
      message = ">> Symbol not found. Would you like to create it?" +
      "\n\n" + term + " definition:";
        
      defInput = createInput();
      defInput.size(400);
      defInput.position(200, input.y + 160);
      create = createButton('create');
      create.position(200, input.y + 200);
      create.mousePressed(addDef);
    }
  }

  input.value('');
 }

function addDef()
{
  ddict[term.toLowerCase()] = defInput.value();
  term = ""; 
  message = "";
  create.remove();
  defInput.remove();
}