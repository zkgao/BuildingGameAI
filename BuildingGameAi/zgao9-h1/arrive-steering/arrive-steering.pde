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

    
    fill(0, 100,0);
    stroke(100);
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
        fill(0,255,0);
        rect(breadx[i]-1, bready[i]-1, 5, 5);
    }
  }
  void update(float time)
  {
    
    position.add(PVector.mult(velocity,time));
    orientation += rotation * time;
    
    velocity.add(PVector.mult(acceleration,time));
    rotation += angluaracceleration *time;
    
    
  }
  float getneworientation()
  {
    
    if(velocity.mag()>0){
      return  -180 * atan2(velocity.y, velocity.x) /PI;
    }
    else return orientation;
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
      
      player.orientation=0;      
      player.rotation=0;
      player.angluaracceleration = 0;
    }
    void face(Agent agent)
    {
        float angle;
      float RODA = 400;
      float ROSA = 10;  
      PVector dir=PVector.sub(target,agent.position);
       angle= -180 * atan2(dir.y, dir.x) /PI;
      float Rot = angle - agent.orientation;
      if(Rot > 180)
        Rot -= 360;
      else if(Rot < -180)
        Rot =(Rot + 360);
      
      float rotation_dir= Rot/abs(Rot);
      
      if(abs(Rot) > RODA)
      {
        agent.angluaracceleration= rotation_dir * max_angular_acceleration;
      }
      else if(abs(Rot) > ROSA)
      {
        agent.angluaracceleration= max_angular_acceleration * Rot / RODA;
      }
      else
      {
        agent.rotation = 0;
        agent.angluaracceleration = 0;
        signal=2;
      }
      
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
        agent.angluaracceleration = 0;
        agent.rotation=0;
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
    //  print(signal);
      if(signal==1)
        face(player);
      if(signal==2){
        arrive(player,target); 
        if(signal != 0 )face(player);
      }
      player.update(0.1);
      player.display();
      fill(255,0,0);
      ellipse(target.x,target.y,4,4);
        
    }
     void mousePressed() 
    {
      // get mouse x and y coordinate, save in target and call arrive
      target.x = mouseX;
      target.y = mouseY;
    
      signal=1;
    }
    
