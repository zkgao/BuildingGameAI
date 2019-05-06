class Agent{
  PVector position;
  PVector velocity;
  PVector acceleration;
  float[] breadx={};
  float[] bready={};
  void display()
  {

    
   fill(0, 100,0);
    stroke(255);
    pushMatrix();
    translate(position.x, position.y);
    rotate(velocity.heading());
    ellipse(0,0,40,40); 
    triangle(5,-1*20,5,20,40,0);
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
        fill(0,255,0);
        rect(breadx[i]-1, bready[i]-1, 5, 5);
    }
  }
  void update(float time)
  {
    
    position.add(PVector.mult(velocity,time));
    
    velocity.add(PVector.mult(acceleration,time));
    
    
  }
}
Agent player=  new Agent();
PVector target = new PVector(0,0);
int signal=0;
float maxspeed=10;
float max_angular_acceleration=10;
void setup()
{
        frameRate(30);
        size(1000,1000);
     player=  new Agent();
       player.position=new PVector(520,520);
      player.velocity = new PVector(0,0);   
      player.acceleration = new PVector(0,0); 
    }
  
    void arrive(Agent agent, PVector target)
    {
      float ROS=0.1;
      float ROD=10;
      float timetotarget=1;
      PVector dir=PVector.sub(target,agent.position);
      float dis=dir.mag();
      if(dis<=ROS)
     {
         agent.acceleration=new PVector(0,0);
         agent.velocity=new PVector(0,0);
        signal=0;
         return ;
     }
      float targetspeed;
      if(dis <= ROS) return ;
      if(dis > ROD)targetspeed=maxspeed;
      else targetspeed=  maxspeed* dis / ROD;
      dir.normalize();
      dir = PVector.mult(dir,targetspeed);
      
      agent.acceleration =( dir.sub( agent.velocity)).div(timetotarget);
  
      
    }
    void draw()
    {
      if(signal==1)
        arrive(player,target);  
      player.update(0.1);
      player.display();
      fill(255,0,0);
      ellipse(target.x,target.y,10,10);
        
    }
     void mousePressed() 
    {
      // get mouse x and y coordinate, save in target and call arrive
      target.x = mouseX;
      target.y = mouseY;
    
      signal=1;
    }
    
