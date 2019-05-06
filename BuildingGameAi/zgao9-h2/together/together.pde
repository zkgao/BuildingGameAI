 import java.util.*;
 class Agent{
  PVector position;
  PVector velocity;
  PVector acceleration;
  float[] breadx={};
  float[] bready={};
  void display()
  {

    
    fill(0, 100,0);
    stroke(100);
    ellipse(position.x,position.y,50,50);  
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
void arrive(Agent agent, PVector targeta)
    {
      float ROS=10;
      float ROD=50;
      float timetotarget=1;
      PVector dir=PVector.sub(targeta,agent.position);
      float dis=dir.mag();
      if(dis<=ROS)
     {
         agent.acceleration=new PVector(0,0);
         agent.velocity=new PVector(0,0);
         pathflag+=1;
         return ;
     }
      float targetspeed;
      if(dis <= ROS) return ;
      if(dis > ROD) targetspeed=maxspeed;
      else targetspeed=  maxspeed* dis / ROD;
      dir.normalize();
      dir = PVector.mult(dir,targetspeed);
      
      agent.acceleration =( dir.sub( agent.velocity)).div(timetotarget);

    }
 PVector target = new PVector(0,0);
 PVector tar;
 Agent player;
 int signal=0;
 int maxspeed=25;

int[][] edge=new int[400][8];
PVector[] DIRS={new PVector(1,0),new PVector(0,1),new PVector(-1,0),new PVector(0,1),new PVector(0,-1),new PVector(-1,-1),new PVector(1,1),new PVector(1,0),new PVector(-1,0),new PVector(0,1),new PVector(0,-1),new PVector(-1,1),new PVector(1,-1)};
PVector[] obs={new PVector(425,425),new PVector(675,675),new PVector(675,425),
new PVector(275,275),new PVector(275,325),new PVector(275,375),new PVector(275,425),new PVector(275,475),new PVector(275,525),new PVector(275,575),new PVector(275,625),new PVector(275,675),new PVector(275,725),new PVector(475,525),new PVector(425,525),new PVector(375,525),new PVector(325,525),new PVector(525,525),new PVector(775,775),new PVector(275,775),new PVector(775,275),
new PVector(325,275),new PVector(375,275),new PVector(425,275),new PVector(475,275),new PVector(525,275),new PVector(575,275),new PVector(625,275),new PVector(675,275),new PVector(725,275),
new PVector(775,375),new PVector(775,425),new PVector(775,475),new PVector(775,525),new PVector(775,575),new PVector(775,625),new PVector(775,675),new PVector(775,725),
new PVector(275,775),new PVector(325,775),new PVector(375,775),new PVector(475,775),new PVector(525,775),new PVector(575,775),new PVector(625,775),new PVector(675,775),new PVector(725,775),
new PVector(525,275),new PVector(525,325),new PVector(525,375),new PVector(525,475),
new PVector(575,525),new PVector(625,525),new PVector(675,525),new PVector(725,525)};
List<PVector> path = new ArrayList<PVector>();
List<PVector> openSet = new ArrayList<PVector>();
List<PVector> closedSet = new ArrayList<PVector>();
float[] cald=new float[400];
int[] pre=new int[400];
int pathflag=0;
PVector localization(PVector p)
{
  PVector r=new PVector((int)p.x*50+25,(int)p.y*50+25);
  return r;
}
PVector quantization(PVector p)
{
 // print(p.x);
  int x=(int)p.x/50;
  int y=(int)p.y/50;
  return new PVector(x,y);
}
float heuristic(PVector a, PVector b)
{
  return dist(a.x,a.y,b.x,b.y);
}
void astar()
{
  if(openSet.size()<=0) return ;
  PVector best=openSet.get(0);
  float bestDis=heuristic(best,tar)+cald[(int)best.x*20+(int)best.y];
  for(int i=1;i<openSet.size();i++)
  {
    PVector choice=openSet.get(i);
    float dis=heuristic(choice,tar)+cald[(int)choice.x*20+(int)choice.y];
    if(dis<bestDis){
      bestDis=dis;
      best=openSet.get(i);
    }
    
  }
  if(best==tar)
  {
    return ;
  }
  for(int d=0;d<8;d++)
       {
        
         PVector neibor=PVector.add(best,DIRS[d]);
     //    print(neibor.x,neibor.y);
          if(!closedSet.contains(neibor) && edge[(int)best.x*20+(int)best.y][d]==1){
              float dis=cald[(int)best.x*20+(int)best.y]+dist(0,0,DIRS[d].x,DIRS[d].y);
              if(cald[(int)neibor.x*20+(int)neibor.y]>dis){
                cald[(int)neibor.x*20+(int)neibor.y]=dis;
                pre[(int)neibor.x*20+(int)neibor.y]=(int)best.x*20+(int)best.y;
              }
              if(!openSet.contains(neibor))
              openSet.add(neibor);
          }
         
       }
       openSet.remove(best);
       closedSet.add(best);
       astar();
}
void pathfinding()
{
  path = new ArrayList<PVector>();
  openSet = new ArrayList<PVector>();
  closedSet = new ArrayList<PVector>();
  for(int i=0;i<cald.length;i++)
  {
    cald[i]=2000;
    pre[i]=-1;
  }
  PVector pp=quantization(player.position);
  openSet.add(pp);
  cald[(int)pp.x*20+(int)pp.y]=0;
  astar();
  PVector temp = tar;
  path.add(0,temp);
  while (pre[(int)temp.x*20+(int)temp.y] != -1) {
    int gg=pre[(int)temp.x*20+(int)temp.y];
    int gx=gg/20;
    int gy=gg-gx*20;
    PVector pg= new PVector(gx,gy);
    path.add(0,pg);
    temp = pg;
  }
}
 void generate()
 {
  // print(1);
//   print(" ");
   for(int i=0;i<20;i++)
   {
     for(int j=0;j<20;j++)
     {
        PVector curr=new PVector(i,j);
       for(int d=0;d<8;d++)
       {
         PVector neibor=PVector.add(curr,DIRS[d]);
         edge[i*20+j][d]=0;
         if(neibor.x>=0 &&neibor.y>=0&&neibor.x<20&&neibor.y<20){
           edge[i*20+j][d]=1;
         for(int o=0;o<obs.length;o++){
           PVector q=quantization(obs[o]);
           if(curr.x==q.x&&curr.y==q.y)
           {
              edge[i*20+j][d]=0;
           }
           if(neibor.x==q.x &&neibor.y==q.y)
           {
            // print("&&");
             //print(q.x,q.y,i,j);
             //print("$$");
             edge[i*20+j][d]=0;
           }
         }
       }
       }
     }
   }
   
 }

 void setup()
 {
     size(1000,1000);
     player=  new Agent();
      player.position=new PVector(25,25);
      player.velocity = new PVector(0,0);   
      player.acceleration = new PVector(0,0);
     //   print(obs.length);
      generate();
 }
 void draw()
 {
  

   for(int i=0;i<obs.length;i++){
  //   print(i);
      if(i<3) fill(0,0,0);
      else fill(255,255,255);
          ellipse(obs[i].x,obs[i].y,20,20);
      }
      if(signal==1){
    //    print(pathflag,signal);
       PVector t =path.get(pathflag);
       arrive(player,localization(t));
       
       if(pathflag>=path.size()){player.position.x=target.x;player.position.y=target.y;signal=0;}
  //     print(pathflag,signal);
      }
     // print(pathflag);
     //  arrive(player,target);
      player.update(1);
      player.display();
      
     //   signal=0;
  // player.acceleration=new PVector(0,0);
  //player.velocity=new PVector(0,0);
      fill(255,0,0);
      ellipse(target.x,target.y,4,4);
      
   
 }
 void mousePressed() 
 {
      // get mouse x and y coordinate, save in target and call arrive
      target.x = mouseX;
      target.y = mouseY;
      tar=quantization(target);
      pathflag=0;
      pathfinding();
      signal=1;
}
