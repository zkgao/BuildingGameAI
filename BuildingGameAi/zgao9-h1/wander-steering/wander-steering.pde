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
    stroke(255);
    pushMatrix();
    translate(position.x, position.y);
    rotate(velocity.heading());
    
    
    ellipse(0,0,20,20); 
    triangle(2.5,-1*10,2.5,10,20,0);

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
        fill(100,100,100);
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
  float getneworientation()
  {
    
    if(velocity.mag()>0){
      return  -180 * atan2(velocity.y, velocity.x) /PI;
    }
    else return orientation;
  }
}
 float wanderori=0;
 float maxspeed=10;
 float offset=50;
 float wanderradix=10;
void wander(Agent agent)
{
   wanderori += random(0,1)-random(0,1);
  PVector target;
  PVector targetori=new PVector(cos(wanderori),sin(wanderori));
//  PVector agentori=new PVector(cos(agent.orientation),sin(agent.orientation));
  PVector agentori=agent.velocity;
  agentori.normalize();
  target=PVector.add(agent.position,PVector.mult( agentori,offset));
  target.add(PVector.mult(targetori,wanderradix));
  arrive(agent,target);
//  face(agent,target);
  
}
void boundary(Agent agent)
{
  if(agent.position.x>1000)
  {
    agent.position.x=0;
  }
  if( agent.position.y>1000)
  {
    agent.position.y=0;
  }
  if(agent.position.x<0)
  {
    agent.position.x=1000;
  }
    
    if(agent.position.y<0)
    {
      agent.position.y=1000;
    }
  
}
 
  void arrive(Agent agent, PVector target)
    {
      float ROD=0.1;
      float ROS=10;
      float timetotarget=10;
      PVector dir=PVector.sub(target,agent.position);
      float dis=dir.mag();
      float targetspeed;
      if(dis < ROD) return ;
      if(dis > ROS) targetspeed=maxspeed;
      else targetspeed=  maxspeed* dis / ROS;
      dir.normalize();
      dir = PVector.mult(dir,targetspeed);
      
      agent.acceleration =( dir.sub( agent.velocity)).div(timetotarget);
      /*
      
      */
    }
    Agent player=new Agent();
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
      void draw()
    {
      wander(player);
      player.update(5);
      boundary(player);
      player.display();
      fill(255,0,0);
    //  ellipse(target.x,target.y,4,4);
        
    }
