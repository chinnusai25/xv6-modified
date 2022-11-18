#include "types.h"
#include "stat.h"
#include "user.h"
int main(){ 
 int pid[25];
    for(int i=0;i<25;i++) {
        pid[i] = fork();
        if(pid[i] == 0) {
            for(int j=0;j<10000000;j++) {
                printf(1,"");
            }
            exit();
        }
    }
    for(int i=0;i<25;i++) {
        int ctime, etime, wtime, rtime;
        int ret = waitx(&wtime, &rtime);
        printf(1, "PID : %d, Waiting time : %d, Running time : %d\n ", ret, wtime, rtime );
    }
    exit();
}