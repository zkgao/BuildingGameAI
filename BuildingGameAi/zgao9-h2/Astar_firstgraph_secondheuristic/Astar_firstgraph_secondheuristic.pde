import java.util.*;
float heuristic(Spot a, Spot b) {
  float d = dist(a.posx, a.posy, b.posx, b.posy);
  return d;
}
float heuristic2(Spot a, Spot b) {
   float d = abs(a.posx - b.posx) + abs(a.posy - b.posy);
  return d;
}
float truedis(Spot a, Spot b) {
  float d = dist(a.posx, a.posy, b.posx, b.posy);
  return d;
}
class Spot{
  int id;
  int posx=0;
  int posy=0;
  float diss=0;
  float h;
  float td;
  List<Spot> neighbors = new ArrayList<Spot>();
  Spot pre=null;

}
List<Spot> graph = new ArrayList<Spot>();
void addnewspot(int id,int posx,int posy)
{
    Spot tmp=new Spot();
    tmp.id=id;
    tmp.posx=posx;
    tmp.posy=posy;
    graph.add(tmp);
}
void addnewedge(int ida,int idb)
{
    Spot sa=graph.get(ida-1);
    Spot sb=graph.get(idb-1);
    sa.neighbors.add(sb);
    sb.neighbors.add(sa);
}
List<Spot> openSet = new ArrayList<Spot>();
List<Spot> closedSet = new ArrayList<Spot>();
Spot start;
Spot end;
Spot current;
void setup()
{
  for(int i=1;i<=19;i++)
  {
      addnewspot(i,i,0);
  }
  addnewspot(20,20,20);
  for(int i=1;i<=19;i++)
  {
      addnewedge(i,i+1);
  }
  addnewedge(1,20);
  start=graph.get(0);
  end=graph.get(19);
  openSet.add(start);
}
int stime;
int timeflag=0;
void draw() {
  if(timeflag==0){
    timeflag=1;
    stime=millis();
  }
  if (openSet.size() > 0) {
    int best = 0;
    float bestdiss=openSet.get(best).diss;
    for (int i = 1; i < openSet.size(); i++) {
      if (openSet.get(i).diss < bestdiss) {
        best = i;
        bestdiss=openSet.get(best).diss;
      }
    }
    current = openSet.get(best);
 //   print(current.id);
    if (current == end) {
      noLoop();
      List<Spot> path = new ArrayList<Spot>();
    Spot temp = current;
    path.add(temp);
    while (temp.pre != null) {
    path.add(temp.pre);
    temp = temp.pre;
    
  }
  println("PATH IS:");
  for(int i=path.size()-1;i>=0;i--){
    print(path.get(i).id);
    print(" ");
  }
   println( " ");
   
  println("Closed Set is:");
  for(int i=0;i<closedSet.size();i++){
    print(closedSet.get(i).id);
    print(" ");
  }
   println( " ");
    println( "runtime:");
    println(millis()-stime);
      println("DONE!");
    }
    openSet.remove(current);
    closedSet.add(current);

    List<Spot> nei = current.neighbors;
    for (int i = 0; i < nei.size(); i++) {
      Spot neighbor = nei.get(i);
      if (!closedSet.contains(neighbor)) {
        float tt = current.td + truedis(neighbor, current);
        boolean newPath = false;
        if (openSet.contains(neighbor)) 
        {
          if (tt < neighbor.td) 
          {
            neighbor.td = tt;
            newPath = true;
          }
        }
        else 
        {
          neighbor.td = tt;
          newPath = true;
          openSet.add(neighbor);
        }
        if (newPath) {
          if(neighbor.id==20&& current.id==1)neighbor.h=404;
          else
          neighbor.h = heuristic2(neighbor, end);
          neighbor.diss = neighbor.td + neighbor.h;
          neighbor.pre = current;
        }
      }
    }
  } else {
    println("no solution");
    noLoop();
    return;
  }
}
