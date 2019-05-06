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
  //  drawBreadCrumbs();
  }
  void leaddisplay()
  {
    
    fill(100, 0,0);
   stroke(255);
    pushMatrix();
    translate(position.x, position.y);
    rotate(velocity.heading());
    
    
    ellipse(0,0,30,30); 
    triangle(2.5,-1*10,2.5,10,20,0);

    popMatrix();
  //  drawBreadCrumbs();
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
    velocity.limit(maxspeed);
    rotation += angluaracceleration *time;
    acceleration.mult(0);
    
    
  }
  float getneworientation()
  {
    
    if(velocity.mag()>0){
      return  -180 * atan2(velocity.y, velocity.x) /PI;
    }
    else return orientation;
  }
}

int num=30;
int lead=1;
float maxspeed=15;
float pdist = 50;
//float minimumPerceptionDistance = 10;
Agent[] agents=new Agent[num];
float maxforce=1;

 void setup()
{
        frameRate(30);
        size(1000,1000);
        for(int i=0;i<num;i++)
        {
            Agent a=new Agent();  
            a.position=new PVector(random(300)+300,random(300)+300);
            a.velocity=new PVector(random(10),random(10));
            a.orientation=a.getneworientation();
            a.rotation=0;
            a.acceleration=new PVector(0,0);
            agents[i]=a;
            print (agents[i]);
        }
        
}
void flocking()
{
  for(int i=0;i<num;i++)
  {
      PVector separation = separation(agents[i]);
      PVector cohesion = cohesion(agents[i]);
      PVector align = align(agents[i]);
      
      PVector weights = new PVector(1.8f, 1.1f, 1.2f);
      //weights.normalize();
      float wx=1.9;
      float wy=1.0;
      float wz=1.1;
      separation.mult(weights.x);
      cohesion.mult(weights.y);
      align.mult(weights.z);
      
      agents[i].acceleration.add(separation);
      agents[i].acceleration.add(cohesion);
      agents[i].acceleration.add(align);
      agents[i].update(0.1); 
     }
}
PVector separation(Agent agent)
    {
      PVector steering = new PVector(0, 0);
      int counter = 0;
      
      for(int i = 0; i < num; i++)
      {
 
        float dis = PVector.dist(agent.position , agents[i].position);
        
        if(dis > 0 && dis < pdist )
        {
          PVector positionDelta = PVector.sub(agent.position, agents[i].position);
          positionDelta.normalize().div(dis);
          steering.add(positionDelta);
          counter++;
        }
          
      }
      if(counter > 0)
        steering.div((float)counter);
      
      if(steering.mag() > 0)
      {
        steering.normalize();
        steering.mult(maxspeed);
        steering.sub(agent.velocity);
         steering.limit(maxforce);
      }
      return steering;
    } 
    PVector align(Agent agent)
    {
      PVector sum = new PVector(0,0);
      int counter = 0;
      for(int i = 0; i < num; i++)
      {
        float positionDist = abs(agent.position.mag() - agents[i].position.mag());
        if(i<lead && (positionDist < pdist))
        {
          agents[i].velocity.normalize().mult(maxspeed);
          return PVector.sub(agents[i].velocity, agent.velocity);
          }
        if(positionDist > 0 && positionDist < pdist)
        {
          sum.add(agents[i].velocity);
          counter++;
        }
      }
      
      if(counter > 0)
      {
        sum.div((float)counter);
        sum.normalize();
        sum.mult(maxspeed);
        PVector steering = PVector.sub(sum, agent.velocity);
        steering.limit(maxforce);
        return steering;
      }
      else
      {
        return new PVector(0,0);
      }
    }
   PVector cohesion(Agent agent)
    {
      PVector sum = new PVector(0,0);
      int counter = 0;
      for(int i = 0; i < num; i++)
      {
        Agent h = agents[i];
        float dis = abs(agent.position.mag() - h.position.mag());
        if(i<lead)
        {
          PVector stickup = PVector.mult(h.velocity, -2).normalize();
          stickup.mult((float)0.25).add(h.position);
          return seek(agent,stickup);
        }
        if(dis > 0 && dis < pdist)
        {
          sum.add(h.position);
          counter++;
        }
      }
      
      if(counter > 0)
      {
        sum.div(counter);
        return seek(agent,sum);
      }
      else
      {
        return new PVector(0, 0);
      }
    }
  PVector seek(Agent agent,PVector target)
    {
     PVector tar = PVector.sub(target, agent.position);
     tar.normalize();
     tar.mult(maxspeed);
      
      PVector steering = PVector.sub(tar, agent.velocity);
      steering.limit(maxforce);
      return steering;
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
void draw()
{
 background(50);
  for(int i=0;i<num;i++){
    if(i<lead)agents[i].leaddisplay();
    boundary(agents[i]);
    agents[i].display();
  }
  flocking();
}
