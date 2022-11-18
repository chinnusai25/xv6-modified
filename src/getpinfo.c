#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
struct proc_stat {
  int pid; // PID of each process
  int runtime; // Use suitable unit of time
  int num_run; // number of time the process is executed
  int current_queue; // current assigned queue
  int ticks[5]; // number of ticks each process has received at each of the 5 priority queue
};


int
main(int argc, char *argv[])
{
	struct proc_stat* process_stat;
	int here_pid;
	here_pid=atoi(argv[1]);
	// printf("asdfg%d\n",here_pid );
  	getpinfo(process_stat,here_pid);
  	// printf("pid : %d\n",(process_stat->pid));
  	// printf("runtime : %d\n",process_stat->runtime);
  	// printf("num_run : %d\n",process_stat->num_run);
  	// printf("current_queue : %d\n",process_stat->current_queue);
  	// printf("ticks[0] : %d\n",process_stat->ticks[0]);
  	// printf("ticks[1] : %d\n",process_stat->ticks[1]);
  	// printf("ticks[2] : %d\n",process_stat->ticks[2]);
  	// printf("ticks[3] : %d\n",process_stat->ticks[3]);
  	// printf("ticks[4] : %d\n",process_stat->ticks[4]);

  	exit();
}