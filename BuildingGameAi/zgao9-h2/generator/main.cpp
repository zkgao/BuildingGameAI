#include <iostream>
#include <cstdlib>
#include <cstdio>
using namespace std;

int main()
{
    for(int i=0;i<1000;i++)
    {
        printf("addnewnode(%d,%d,%d);\n",i,rand()%1000,rand()%1000);
    }
    for(int i=0;i<5000;i++)
    {
        int a=rand()%1000;
        int b=rand()%1000;
        if(b==a)b++;
        printf("addnewedge(%d,%d);\n",a,b);

    }
    return 0;
}
