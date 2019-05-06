class Agent{
  PVector position;
  PVector velocity;
  PVector acceleration;
  float angluaracceleration;
  float orientation;
  float rotation;
  float[] breadx={};
  float[] bready={};
  void display()
  {
    fill(0,100,0);
    stroke(255);
    ellipse(position.x,position.y,40,40);  
    pushMatrix();
   translate(position.x,position.y);
   rotate(PApplet.radians(360-orientation));
   triangle(5,-1*20,5,20,40,0);
    rotate(PApplet.radians(360-orientation));
    popMatrix();
    drawBreadCrumbs();
  }
  void drawBreadCrumbs()
  {
  

      PVector temp = new PVector(position.x-5, position.y-5);
     breadx=append(breadx,temp.x);
     bready=append(bready,temp.y);
  
    for(int i=0 ; i < breadx.length; i++)
    {
        fill(0,0,0);
    rect(breadx[i]-1, bready[i]-1, 2, 2);
    }
  }
  void update(float time)
  {
 
    position.add(PVector.mult(velocity,time));
    orientation += rotation * time;
    velocity.add(PVector.mult(acceleration,time));
    rotation += angluaracceleration *time;
    
  }
  void getneworientation()
  {
    
    if(velocity.mag()>0){
      orientation= -180 * atan2(velocity.y, velocity.x) /PI;
    }
    
  }
}

Agent player=  new Agent();
void setup()
{
        frameRate(30);
        size(1000,1000);
     player=  new Agent();
       player.position=new PVector(20,980);
      player.velocity = new PVector(1,0);   
      player.acceleration = new PVector(0,0); 
      
      player.orientation=0;      
      player.rotation=0;
      player.angluaracceleration = 0;
    
      

    }
    void basicmove(Agent agent){
    //  print(agent.velocity.y);
      if(agent.position.x >= 960 && agent.position.y==980  )
      {
        agent.position=new PVector(960,980);
        agent.velocity=new PVector(0,-1);
        agent.getneworientation();
        print(agent.orientation);
        
      }
      else if(agent.position.x == 960 && agent.position.y<=40  )
      {
        agent.position=new PVector(960,40);
        agent.velocity=new PVector(-1,0);
        agent.getneworientation();
        print(agent.orientation);
        
      }
      else if(agent.position.x <= 40 && agent.position.y==40  )
      {
        agent.position=new PVector(40,40);
        agent.velocity=new PVector(0,1);
        agent.getneworientation();
        print(agent.orientation);
        
      }
      else if(agent.position.x==40 && agent.position.y==960)
      {
        agent.velocity=new PVector(0,0);
      }
    }
    void draw()
    {
      player.display();
      player.update(10);
      basicmove(player);
     
    }
