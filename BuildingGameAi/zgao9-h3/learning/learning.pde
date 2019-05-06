
 import java.util.*;
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
new PVector(525,75),new PVector(525,125),new PVector(525,175),new PVector(525,225),new PVector(525,325),new PVector(525,375),new PVector(525,425),new PVector(525,475),new PVector(525,525),new PVector(225,125),new PVector(625,275),new PVector(825,125),
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
 
 int cnt=0;

float lg(float a,float b)
{
  if(a<=0.005 || b<=0.005)return 0.0;
  else return(log(a/b)/log(2));
}
float calgain(float a1,float a2,float a3)
{
  float sum=a1+a2+a3;
  //print(sum);
  if(sum<=0.5)return 0;
  return -1*(a1/sum*lg(a1,sum)+a2/sum*lg(a2,sum)+a3/sum*lg(a3,sum));
}
class data{
  int aid;
  int[] f;
  data(int a,int[] fe)
  {
    aid=a;
    f=fe;
  }
};
int[] current;
class treenode{
int featurename;
int[] attributes;
int aid;
treenode child1;
treenode child2;
treenode child3;
int run()
{
  if(featurename<0)return aid;
  if(current[featurename]==1)return child1.run();
  else if(current[featurename]==2)return child2.run();
  else return child3.run();
}
}
void createtree(treenode tn,data[] dn)
{
  if(dn.length==0)
  {
    tn.featurename=-1;
      tn.aid=-2;
      return ;
  }
  else if(tn.attributes.length==0)
  {
 //   print("X");
    int a1=0,a2=0,a3=0;
    for(int i=0;i<dn.length;i++)
    {
      if(dn[i].aid==1)a1++;
      else if(dn[i].aid==2)a2++;
      else if(dn[i].aid==3)a3++;
    }
    if(a1>=a2 && a1>=a3)tn.aid=1;
   else if(a2>=a1 && a2>=a3)tn.aid=2;
   else if(a3>=a1 && a3>=a2)tn.aid=3;
   tn.featurename=-1;
   return ;
  }
 
  int bestid=-1;
  float bestgain=-1.0;
  for(int i=0;i<tn.attributes.length;i++)
  {
    float g1,g2,g3;
    int f1=0,f2=0,f3=0;
    int a11=0,a12=0,a13=0;
    int a21=0,a22=0,a23=0;
    int a31=0,a32=0,a33=0;
  //  print(dn.length);
    for(int j=0;j<dn.length;j++)
    {  

      if(dn[j].f[i]==1){
        f1++;
         if(dn[j].aid==1)a11++;
         else if(dn[j].aid==2)a12++;
         else if(dn[j].aid==3)a13++;
         
      }
      else if(dn[j].f[i]==2){
        f2++;
      
         if(dn[j].aid==1)a21++;
         else if(dn[j].aid==2)a22++;
         else if(dn[j].aid==3)a23++;
         
      }
      else
      {
        f3++;
        
         if(dn[j].aid==1)a31++;
         else if(dn[j].aid==2)a32++;
         else if(dn[j].aid==3)a33++;
         
      }
    }
    g1=calgain(a11*1.0,a12*1.0,a13*1.0);
    g2=calgain(a21*1.0,a22*1.0,a23*1.0);
    g3=calgain(a31*1.0,a32*1.0,a33*1.0);
    float gain=g1*f1/dn.length+g2*f2/dn.length+g3*f3/dn.length;
    int a1=a11+a21+a31;
    int a2=a12+a22+a32;
     int a3=a13+a23+a33;
    float totalgain=calgain(a1*1.0,a2*1.0,a3*1.0);
    float ig=totalgain-gain;
    //println(dn.length,a11,a12,a13,g1,g2,g3,gain,totalgain,ig);
    if(ig>bestgain)
    {
        bestid=tn.attributes[i];
        bestgain=ig;
    }
    
  }
//  println(bestid);
  
  data[] dn1tmp=new data[dn.length];
  data[] dn2tmp=new data[dn.length];
  data[] dn3tmp=new data[dn.length];
  int cnt1=0,cnt2=0,cnt3=0;
    for(int i=0;i<dn.length;i++)
    {
      if(dn[i].f[bestid]==1)
      {
        dn1tmp[cnt1]=dn[i];
        cnt1++;
      }
       else if(dn[i].f[bestid]==2)
      {
        dn2tmp[cnt2]=dn[i];
        cnt2++;
      }
       else if(dn[i].f[bestid]==3)
      {
        dn3tmp[cnt3]=dn[i];
        cnt3++;
      }
    }
    data[] dn1=new data[cnt1];
    arrayCopy(dn1tmp,dn1,cnt1);
   // print(dn1.length);
    data[] dn2=new data[cnt2];
    arrayCopy(dn2tmp,dn2,cnt2);
    data[] dn3=new data[cnt3];
    arrayCopy(dn3tmp,dn3,cnt3);
    tn.child1=new treenode();
    tn.child1.attributes=new int[tn.attributes.length-1];
    int cntt=0;
    for(int i=0;i<tn.attributes.length;i++)
    {
  //    println(bestid,tn.attributes[i],tn.attributes.length);
      if(tn.attributes[i]!=bestid){
         tn.child1.attributes[cntt]=tn.attributes[i];
         cntt++;
      }
    }
    int[] empty={};
    if(tn.attributes.length==1)tn.child1.attributes=empty;
 //   print("S");
    tn.child2=new treenode();
    tn.child2.attributes=tn.child1.attributes;
  //  println("m"+tn.child2.attributes.length);
   
    tn.child3=new treenode();
    tn.child3.attributes=tn.child1.attributes;
    tn.featurename=bestid;
    tn.aid=-1;
     createtree(tn.child1,dn1);
    // print("F");
     createtree(tn.child2,dn2);
    createtree(tn.child3,dn3);
    
}
data[] t=new data[6965];
treenode rt;
int stime;
void setup()
{
  //size(100, 100);
  cnt=0;
  parseFile();
  rt=new treenode();
int[] att={0,1,2,3,4,5};
rt.attributes=att;
createtree(rt,t);
size(1000,1000);
     frameRate(50);
     player=  new Agent();
        monster=  new Agent();
     setplayer();
     //   print(obs.length);
      generate();
      builddt();
    //  print("S");
      gold=new PVector(225,225);
      stime=0;
      current=new int[6];
      unmask=0;

}
void parseFile() {
  BufferedReader reader = createReader("p.txt");
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      String[] pieces = split(line, ',');
      int f2,f3,f4,f5,f6;
      int f0 = int(pieces[0]);
      int f1 = int(pieces[1]);
      float dis=float(pieces[2]);
      float distod1=float(pieces[3]);
      float distod2=float(pieces[4]);
      f5=int(pieces[5]);
      int time=int(pieces[6]);
      f1++;
      if(dis<=200)f2=1;
      else if(dis<=400)f2=2;
      else f2=3;
      if(distod1<=300)f3=1;
      else if(distod1<=400)f3=2;
      else f3=3;
      if(distod2<=200)f4=1;
      else if(distod2<=350)f4=2;
      else f4=3;
      f5++;
      if(time<=1000)f6=1;
      else if(time<=2000)f6=2;
      else f6=3;
      int[] fs={f1,f2,f3,f4,f5,f6};
      data da=new data(f0-1,fs);
      t[cnt]=da;
     cnt++;
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
} 
int timeflag=0;
int unmask=0;
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
    if(player.room()==2)current[0]=2;
    else current[0]=1;
      float dis=dist(player.position.x,player.position.y,monster.position.x,monster.position.y);
  float distod1=dist(monster.position.x,monster.position.y,225,575);
  float distod2=dist(monster.position.x,monster.position.y,775,575);
      if(dis<=200)current[1]=1;
      else if(dis<=400)current[1]=2;
      else current[1]=3;
      if(distod1<=300)current[2]=1;
      else if(distod1<=400)current[2]=2;
      else current[2]=3;
      if(distod2<=200)current[3]=1;
      else if(distod2<=350)current[3]=2;
      else current[3]=3;
  int timedis=millis()-stime;

  if(gold.y==725)current[4]=2;
  else if(gold.y==575)current[4]=3;
  else current[4]=1;
 // println(current[0]+" "+current[1]+" "+current[2]+" "+current[3]+" "+current[4]);
  if(timedis<=1000)current[5]=1;
      else if(timedis<=2000)current[5]=2;
      else current[5]=3;
  
  
     take_action(root.run());
     take_monster_action(rt.run());
    // htroot.run();
     pathfollowing();
     // print(pathflag);
     //  arrive(player,target);
      player.update(1);
      player.display();
      
      monster.update(1);
      monster.display();
      if(dist(player.position.x,player.position.y,monster.position.x,monster.position.y)<=40)
      {
          setplayer();
           goldplace=1;
         gold=new PVector(225,225);
         stime=millis();
      }
 }
 void take_monster_action(int aid)
 {
 //  println(aid);
   if(aid==1)chase(monster,player.position);
   else if(aid==2)chase(monster,new PVector(225,575));
   else if(aid==3) chase(monster,new PVector(775,575));
   else unmask++;
 }
