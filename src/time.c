#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

int main (int argc,char *argv[])
{

	int pid;
	int process_pid=-1, wait_time, run_time;	
	pid = fork();
	if (pid == 0)
  	{	
  		exec(argv[1], argv);
    	printf(1, "exec %s failed\n", argv[1]);
    }
  	else
 	{
    	process_pid = waitx(&wait_time, &run_time);
 	}  
 	printf(1, "Wait Time = %d\n Run Time = %d of process with pid %d \n", wait_time, run_time, process_pid); 
 	exit();
}
