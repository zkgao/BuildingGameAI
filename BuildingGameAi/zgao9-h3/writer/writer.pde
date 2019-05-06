 import java.util.*;
PrintWriter output;
int stime=0;
void recorddata(int aid)
{
  int same_room=0;
  if(player.room()==2)same_room=1;
  float dis=dist(player.position.x,player.position.y,monster.position.x,monster.position.y);
  float distod1=dist(monster.position.x,monster.position.y,225,575);
  float distod2=dist(monster.position.x,monster.position.y,775,575);
  int timedis=millis()-stime;
  int goldp=0;
  if(gold.y==725)goldp=1;
  else if(gold.y==575)goldp=2;
  if(aid!=1)
  output.println(aid+","+same_room +","+ dis +","+ distod1+","+distod2+","+goldp+","+timedis);
  
}
class htnode
{
htnode child1;
htnode child2;
int type;
int aid;
htnode(int t,int a)
{
  type=t;
  aid=a;
}
htnode(int t,int a,htnode c1,htnode c2)
{
  type=t;
  aid=a;
  child1=c1;
  child2=c2;
}
boolean run()
{
  if(type==1)
  {
    if(child1.run())return true;
    else if(child2.run())return true;
    else return false;
  }
  else if(type==2){
  if(child1.run())return child2.run();
  else return false;
  }
  else if(type==3){
    int rd=(int)random(2);
    if(rd<1){
    if(child1.run())return true;
    else if(child2.run())return true;
    else return false;
    }
    else{
    if(child2.run())return true;
    else if(child1.run())return true;
    else return false;
    }
  }
  else
    return takeaction();
}
boolean takeaction()
{
  recorddata(aid);
  if(aid==1){
  //   print ("++++++++++++++++++++++");
    if(player.room()==2)return true;
    else return false;
  }
  else if(aid==2){
    chase(monster,player.position);
    return true;
  }
  else if(aid==3){
    chase(monster,new PVector(225,575));
    return true;
  }
  else{
    chase(monster,new PVector(775,575));
    return true;
  }
  
    
}
}
boolean[] pcurrent={false,false,false,false,false};
void setpcurrent()
{
  if(player.room()==1)pcurrent[0]=true;
  if(player.room()==2)pcurrent[2]=true;
  if(goldplace==1)pcurrent[1]=true;
  if(goldplace==2)pcurrent[3]=true;
  if(goldplace==3)pcurrent[4]=true;
  
}
class dtnode
{
  dtnode child_true;
  dtnode child_false;
  int id;
  int action;
  dtnode(int i,int a){
    id=i;
    action=a;
  }
  dtnode(int i,int a,dtnode t,dtnode f){
    id=i;
    action=a;
    child_true=t;
    child_false=f;
  }
  boolean condition()
  {
    setpcurrent();
    return pcurrent[id];
  }  
  int run()
  {
    if(action!=-1)return action;
    if(condition())
      return child_true.run();
    else
      return child_false.run();
  }
 
}
 class Agent{
  PVector position;
  PVector velocity;
  PVector acceleration;
  float[] breadx={};
  float[] bready={};
  int mflag;
  void display()
  {
    if(mflag==1)fill(100,0,0);
    else fill(0, 100,0);
    
    stroke(255);
    pushMatrix();
    translate(position.x, position.y);
    rotate(velocity.heading());
    
    
    ellipse(0,0,20,20); 
   // triangle(5,-1*20,5,20,40,0);

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
        if(mflag==1)fill(100,0,0);
    else fill(0, 100,0);
        rect(breadx[i]-1, bready[i]-1, 5, 5);
    }
  }
  void update(float time)
  {
    
    position.add(PVector.mult(velocity,time));
    velocity.add(PVector.mult(acceleration,time));
  }
  int room()
  {
    if(position.x<550 &&position.x>50 &&position.y<500 &&position.y>50)
        return 1;
    
    if(position.x<950 &&position.x>550 &&position.y<500 &&position.y>50)
        return 3;
    
    else
        return 2;
  }
}
void chase(Agent agent, PVector targeta)
    {
      PVector dir=PVector.sub(targeta,agent.position);
      float dis=dir.mag();
      float targetspeed=15;

      dir.normalize();
      dir = PVector.mult(dir,targetspeed);
      
      agent.acceleration =dir.sub( agent.velocity);

    }
void arrive(Agent agent, PVector targeta)
    {
      float ROS=25;
      float ROD=50;
      float timetotarget=1;
      PVector dir=PVector.sub(targeta,agent.position);
      float dis=dir.mag();
   //   print(dis);
    //  print(targeta.x,targeta.y,agent.position.x,agent.position.y);
      if(dis<=ROS)
     {
 
         agent.acceleration=new PVector(0,0);
    //     agent.velocity=new PVector(1,1);
         pathflag+=1;
         
         if(targeta.x==gold.x&&targeta.y==gold.y)changegold();
       //  print(pathflag);
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
 Agent monster;
 int signal=0;
float maxspeed=25;
int goldplace=1;
PVector gold;
int[][] edge=new int[400][8];
PVector[] DIRS={new PVector(1,0),new PVector(0,1),new PVector(-1,0),new PVector(0,1),new PVector(0,-1),new PVector(-1,-1),new PVector(1,1),new PVector(1,0),new PVector(-1,0),new PVector(0,1),new PVector(0,-1),new PVector(-1,1),new PVector(1,-1)};
PVector[] obs={new PVector(25,25),new PVector(75,25),new PVector(125,25),new PVector(175,25),new PVector(225,25),new PVector(275,25),new PVector(325,25),new PVector(375,25),new PVector(425,25),new PVector(475,25),new PVector(525,25),new PVector(575,25),new PVector(625,25),new PVector(675,25),new PVector(725,25),new PVector(775,25),new PVector(825,25),new PVector(875,25),new PVector(925,25),new PVector(975,25),
new PVector(25,975),new PVector(75,975),new PVector(125,975),new PVector(175,975),new PVector(225,975),new PVector(275,975),new PVector(325,975),new PVector(375,975),new PVector(425,975),new PVector(475,975),new PVector(525,975),new PVector(575,975),new PVector(625,975),new PVector(675,975),new PVector(725,975),new PVector(775,975),new PVector(825,975),new PVector(875,975),new PVector(925,975),new PVector(975,975),
new PVector(25,75),new PVector(25,125),new PVector(25,175),new PVector(25,225),new PVector(25,275),new PVector(25,325),new PVector(25,375),new PVector(25,425),new PVector(25,475),new PVector(25,525),new PVector(25,575),new PVector(25,625),new PVector(25,675),new PVector(25,725),new PVector(25,775),new PVector(25,825),new PVector(25,875),new PVector(25,925),
new PVector(975,75),new PVector(975,125),new PVector(975,175),new PVector(975,225),new PVector(975,275),new PVector(975,325),new PVector(975,375),new PVector(975,425),new PVector(975,475),new PVector(975,525),new PVector(975,575),new PVector(975,625),new PVector(975,675),new PVector(975,725),new PVector(975,775),new PVector(975,825),new PVector(975,875),new PVector(975,925),
new PVector(525,75),new PVector(525,125),new PVector(525,175),new PVector(525,225),new PVector(525,325),new PVector(525,375),new PVector(525,425),new PVector(525,475),new PVector(525,525),
new PVector(75,525),new PVector(125,525),new PVector(175,525),new PVector(275,525),new PVector(325,525),new PVector(375,525),new PVector(425,525),new PVector(475,525),new PVector(575,525),new PVector(625,525),new PVector(675,525),new PVector(725,525),new PVector(825,525),new PVector(875,525),new PVector(925,525)};
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
void builddt()
{
  dtnode n11=new dtnode(11,4);
  dtnode n10=new dtnode(10,1);
  dtnode n9=new dtnode(9,3);
  dtnode n8=new dtnode(8,1);
  dtnode n7=new dtnode(4,-1,n10,n11);
  dtnode n6=new dtnode(3,-1,n8,n9);
  dtnode n5=new dtnode(5,2);
 dtnode n4=new dtnode(4,1);
 dtnode n3=new dtnode(2,-1,n6,n7);
 dtnode n2=new dtnode(1,-1,n4,n5);
 dtnode n1=new dtnode(0,-1,n2,n3);
 root=n1;
}
void buildht()
{
  htnode n7=new htnode(0,4);
  htnode n6=new htnode(0,3);
  htnode n5=new htnode(0,2);
  htnode n4=new htnode(0,1);
  htnode n3=new htnode(3,0,n6,n7);
  htnode n2=new htnode(2,0,n4,n5);
  htnode n1=new htnode(1,0,n2,n3);
  htroot=n1;
}
dtnode root;
htnode htroot;
void setplayer()
{
   player.position=new PVector(125,125);
      player.velocity = new PVector(0,0);   
      player.acceleration = new PVector(0,0);
      player.mflag=0;
        monster.position=new PVector(525,925);
      monster.velocity = new PVector(0,0);   
      monster.acceleration = new PVector(0,0);
       monster.mflag=1;
}
 void setup()
 {
   output = createWriter("p.txt"); 
     size(1000,1000);
     frameRate(50);
     player=  new Agent();
     
        monster=  new Agent();
     setplayer();
     //   print(obs.length);
      generate();
      builddt();
      buildht();
    //  print("S");
      gold=new PVector(225,225);
      
 }
 void pathfollowing()
 {
 //  print(signal);
 if(signal==1){
  // print(pathflag,path.size());
       if(pathflag>=path.size()){
        player.acceleration=new PVector(0,0);
         player.velocity=new PVector(0,0);
 //        pathflag+=1;
      //   print(gold.x,gold.y);
         if(target.x-gold.x<=1&&target.y-gold.y<=1)changegold();
       signal=0;}
       else{
    //    print(pathflag,path.size());
       PVector t =path.get(pathflag);
       arrive(player,localization(t));
       }
       
  //     print(pathflag,signal);
      }
 }
 void changegold()
 {
   if(goldplace==1){
   goldplace=2;
   if(random(2)<1)
   gold=new PVector(525,725);
    else
   gold=new PVector(525,575);
   }
  else if(goldplace==2){
   goldplace=3;
   
   gold=new PVector(725,225);
  
   }
   else if(goldplace==3){
   goldplace=1;
   gold=new PVector(225,225);
   }
 }
 void take_action(int action)
 {
 //  if(signal==0)return ;
   if(action==1)
     target=gold;
   else if(action==2)
     target=new PVector(225,575);
   else if(action==3)
      target=new PVector(775,425);
    else if(action==4)
      target=new PVector(475,275);
     tar=quantization(target);
      pathflag=1;

      pathfinding();
      signal=1;
 }
 int timeflag=0;
 void draw()
 {
   if(timeflag==0){
     timeflag=1;
     stime=millis();
   }
  background(100);

   for(int i=0;i<obs.length;i++){
  //   print(i);
    fill(0,0,0);
          rect(obs[i].x-25,obs[i].y-25,50,50);

      }
      fill(255,255,255);
        rect(gold.x-25,gold.y-25,50,50);
    // print('S',goldplace,root.run(),'X');
     take_action(root.run());
     htroot.run();
     pathfollowing();
     // print(pathflag);
     //  arrive(player,target);
      player.update(1);
      player.display();
      if(dist(player.position.x,player.position.y,monster.position.x,monster.position.y)<=50)
      {
          setplayer();
           goldplace=1;
         gold=new PVector(225,225);
         stime=millis();
      }
      monster.update(1);
      monster.display();
      
     //   signal=0;
  // player.acceleration=new PVector(0,0);
  //player.velocity=new PVector(0,0);   
 }
void keyPressed() {
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  exit(); // Stops the program
}
