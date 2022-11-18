#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include <stddef.h>

/**** for mlfq *****/
struct proc* q0[64];
struct proc* q1[64];
struct proc* q2[64];
struct proc* q3[64];
struct proc* q4[64];
int c0 =-1;
int c1=-1;
int c2=-1;
int c3=-1;
int c4=-1;
int clkPerPrio[5] ={1,2,4,8,16};
// struct pstat pstat_var;		// this is proc_stat according to assignment
/**** above for mlfq ***/

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);
// extern int type;
static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->priority=60;	// used for pbs
  p->current_queue = 0; // used for mlfq
  p->ticks[0] = p->ticks[1] = p->ticks[2] = p->ticks[3] = p->ticks[4] = 0;
  p->lastexperiencedtick=0;
  c0++;
  q0[c0] = p;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
// adding time fields
  p->stime = ticks;         // start time
  p->etime = 0;             // end time
  p->rtime = 0;             // run time
  p->iotime = 0;            // I/O time
  
  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  curproc->etime = ticks; 

  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//current process status
int
cps()
{
  struct proc *p;
  
  // Enable interrupts on this processor.
  sti();
// cprintf("outps");
    // Loop over process table looking for process with pid.
  acquire(&ptable.lock);
// cprintf("inps");
  
  cprintf("name \t pid \t queueNo \t ticks \t state \t priority\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if ( p->state == SLEEPING )
        cprintf("%s \t %d  \t %d  \t %d  \t SLEEPING \t %d\n  ", p->name, p->pid ,p->current_queue,p->ticks[p->current_queue],p->priority);
      else if ( p->state == RUNNING )
        cprintf("%s \t %d  \t %d  \t %d  \t RUNNING \t %d\n ", p->name, p->pid,p->current_queue,p->ticks[p->current_queue],p->priority );
  	  else if ( p->state == RUNNABLE )
        cprintf("%s \t %d  \t %d  \t %d  \t RUNNABLE \t %d\n ", p->name, p->pid,p->current_queue,p->ticks[p->current_queue],p->priority );	
  }
  
  release(&ptable.lock);
  
  return 23;
}

int set_priority(int pid,int new_priority){
	struct proc *p;
    int old_priority=-1;
    // cprintf("out");
    acquire(&ptable.lock);
    // cprintf("in");

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid ) {
        old_priority = p->priority;
        p->priority = new_priority;
        break;
    }
  }
    // cprintf("exit");

  	release(&ptable.lock);
    // cprintf("out");

  return old_priority;
}

int getpinfo(struct proc_stat*process_stat,int here_pid){
	int i = 0;
  	acquire(&ptable.lock);
  	struct proc*p;
  	// Update process_stat table information
			// cprintf("ff%d\n",here_pid);

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  		if(p->pid==here_pid){
  			process_stat->num_run = p->num_run;
			process_stat->runtime = p->rtime;
			process_stat->pid = p->pid;
			process_stat->ticks[0] = p->ticks[0];
			process_stat->ticks[1] = p->ticks[1];
			process_stat->ticks[2] = p->ticks[2];
			process_stat->ticks[3] = p->ticks[3];
			process_stat->ticks[4] = p->ticks[4];
			process_stat->current_queue = p->current_queue;
			cprintf("pid : %d\n",(process_stat->pid));
  	cprintf("runtime : %d\n",process_stat->runtime);
  	cprintf("num_run : %d\n",process_stat->num_run);
  	cprintf("current_queue : %d\n",process_stat->current_queue);
  	cprintf("ticks[0] : %d\n",process_stat->ticks[0]);
  	cprintf("ticks[1] : %d\n",process_stat->ticks[1]);
  	cprintf("ticks[2] : %d\n",process_stat->ticks[2]);
  	cprintf("ticks[3] : %d\n",process_stat->ticks[3]);
  	cprintf("ticks[4] : %d\n",process_stat->ticks[4]);
  		}
  	}
// 	 int inuse[NPROC];  // whether this slot of the process process table is in use (1 or 0)
//     int pid[NPROC];    // the PID of each process
//     int hticks[NPROC]; // the number of ticks each process has accumulated at priority 2
//     int lticks[NPROC]; // the number of ticks each process has accumulated at priority 1
  	
//   	for(i = 0; i < NPROC; ++i) {
//     	struct proc p = ptable.proc[i];
//     // 	if(p.state == UNUSED) {
//     //   		process_stat->inuse[i] = 0;
//     // 	}
//     // else {
//     //   process_stat->inuse[i] = 1;
//     // }
// 			process_stat->num_run[i] = p.num_run;
// 			process_stat->runtime[i] = p.rtime;
// 			// process_stat->ticks[i][0] = p.ticks[0];
// 			// process_stat->ticks[i][1] = p.ticks[1];
// 			// process_stat->ticks[i][2] = p.ticks[2];
// 			// process_stat->ticks[i][3] = p.ticks[3];
// 			// process_stat->ticks[i][4] = p.ticks[4];
// 			// process_stat->current_queue[i] = p.current_queue;


// //     //   process_stat->hticks[i] = p.highPriorityTime;
// //     //   process_stat->lticks[i] = p.lowPriorityTime;
//        		process_stat->pid[i] = p.pid;
//   }
  release(&ptable.lock);
  return 0;
}

int
waitx(int *wtime, int *rtime)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.

        // Added time field update, else same from wait system call
        *wtime = p->etime - p->stime - p->rtime - p->iotime;
        // *wtime=p->etime;
        *rtime = p->rtime;

        // same as wait 
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct proc *temp_proc;
  struct proc *current_process;
  struct cpu *c = mycpu();
  c->proc = 0;
  int i,j,z;
  int lastScheduled=-1;
  // cprintf("please-%d",type);
  for(;;){
    // Enable interrupts on this processor.
    sti();
      uint xticks;
    acquire(&tickslock);
    xticks = ticks;
    release(&tickslock);
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    // for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    // 	cprintf("sai-%d",p);
    //   if(p->state != RUNNABLE)
    //     continue;

    //   // Switch to chosen process.  It is the process's job
    //   // to release ptable.lock and then reacquire it
    //   // before jumping back to us.
    //   c->proc = p;
    //   switchuvm(p);		// defined in vm.c
    //   p->state = RUNNING;
    //   p->num_run++;
    //   swtch(&(c->scheduler), p->context);
    //   switchkvm();		// defined in vm.c

    //   // Process is done running for now.
    //   // It should have changed its p->state before coming back.
    //   c->proc = 0;
    // }

    // if(argv[2]=="SCHEDULER=MLFQ"){
    #ifdef MLFQ
    int flag1=0;
    	for(j = 0; j < NPROC; ++j){
          if( ptable.proc[j].state != RUNNABLE) continue;
          if(ptable.proc[j].current_queue > 0 && xticks - ptable.proc[j].lastexperiencedtick >= 100){
            if(ptable.proc[j].current_queue==1){
            	for(int y=0;y<=c1;y++){
            		if(q1[y]->pid==ptable.proc[j].pid){
            			 q1[y]=NULL;
					  for(z=y;z<=c1-1;z++)
					  q1[z] = q1[z+1];
					  q1[c1] = NULL;
					  c1--;
            		}
            	}
            	c0++;
            	q0[c0]=&ptable.proc[j];
            }
            if(ptable.proc[j].current_queue==2){
            	for(int y=0;y<=c2;y++){
            		if(q2[y]->pid==ptable.proc[j].pid){
            			 q2[y]=NULL;
					  for(z=y;z<=c2-1;z++)
					  q2[z] = q2[z+1];
					  q2[c2] = NULL;
					  c2--;
            		}
            	}
            	c1++;
            	q1[c1]=&ptable.proc[j];
            }
            if(ptable.proc[j].current_queue==3){
            	for(int y=0;y<=c3;y++){
            		if(q3[y]->pid==ptable.proc[j].pid){
            			 q3[y]=NULL;
					  for(z=y;z<=c3-1;z++)
					  q3[z] = q3[z+1];
					  q3[c3] = NULL;
					  c3--;
            		}
            	}
            	c2++;
            	q2[c2]=&ptable.proc[j];
            }
            if(ptable.proc[j].current_queue==4){
            	for(int y=0;y<=c4;y++){
            		if(q4[y]->pid==ptable.proc[j].pid){
            			 q4[y]=NULL;
					  for(z=y;z<=c4-1;z++)
					  q4[z] = q4[z+1];
					  q4[c4] = NULL;
					  c4--;
            		}
            	}
            	c3++;
            	q3[c3]=&ptable.proc[j];
            }
            ptable.proc[j].current_queue--;
          	// cprintf("pid-%d q-%d\n",ptable.proc[j].pid,ptable.proc[j].current_queue);
          }
        }
    	if(c0!=-1){
					for(i=0;i<=c0;i++){
						if(q0[i]->state != RUNNABLE)
							  continue;
					  p=q0[i];
					  c->proc = q0[i];
					  p->lastexperiencedtick = xticks;
					  lastScheduled = p - ptable.proc;
					  switchuvm(p);
					  p->state = RUNNING;
					  p->num_run++;
					  swtch(&(c->scheduler), p->context);
					  switchkvm();
					  if(p->ticks[0]!=0 && p->ticks[0]%(clkPerPrio[0]*10)==0){
						  /*copy proc to lower priority queue*/
						  c1++;
						  c->proc->current_queue=1;
						  q1[c1] = c->proc;

						  /*delete proc from q0*/
						  q0[i]=NULL;
						  for(j=i;j<=c0-1;j++)
							  q0[j] = q0[j+1];
						  q0[c0] = NULL;
						  c0--;
					  }

					  c->proc = 0;
					}
				}
		if(c1!=-1){
			for(i=0;i<=c1;i++){
				// if(c0!=-1)break;
				for(int u=0;u<=c0;u++){
						if(q0[u]->state == RUNNABLE){
					  	flag1=1;
					  	break;
						}
					}
					if(flag1==1){
						break;
					}	
				if(q1[i]->state != RUNNABLE)
					continue;
			          p=q1[i];
					  c->proc = q1[i];
					  p->lastexperiencedtick = xticks;
					  lastScheduled = p - ptable.proc;
					  switchuvm(p);
					  p->state = RUNNING;
					  p->num_run++;

					  swtch(&(c->scheduler), p->context);
					  switchkvm();
					  if(p->ticks[1]!=0 && p->ticks[1]%(clkPerPrio[1]*10) == 0 ){

					  /*copy proc to lower priority queue*/
					  c2++;
					  c->proc->current_queue=2;
					  q2[c2] = c->proc;

					  /*delete proc from q0*/
					  q1[i]=NULL;
					  for(j=i;j<=c1-1;j++)
					  q1[j] = q1[j+1];
					  q1[c1] = NULL;
					  c1--;
					  }
					  c->proc = 0;
					}
				}

				if(c2!=-1){
				// if(c0!=-1)break;
				// if(c1!=-1)break;

					for(i=0;i<=c2;i++){
						for(int u=0;u<=c0;u++){
						if(q0[u]->state == RUNNABLE){
					  	flag1=1;
					  	break;
						}
					}
					if(flag1==1){
						break;
					}	
					for(int u=0;u<=c1;u++){
						if(q1[u]->state == RUNNABLE){
					  	flag1=1;
					  	break;
						}
					}
					if(flag1==1){
						break;
					}	
						  if(q2[i]->state != RUNNABLE)
							  continue;
						  p=q2[i];
						  c->proc = q2[i];
						  p->lastexperiencedtick = xticks;
						  lastScheduled = p - ptable.proc;
						  switchuvm(p);
						  p->state = RUNNING;
					  		p->num_run++;

					      swtch(&(c->scheduler), p->context);
						  switchkvm();
						  if(p->ticks[2]!=0 && p->ticks[2]%(clkPerPrio[2]*10)==0){
													  /*copy proc to lower priority queue*/
						  c3++;
						  c->proc->current_queue=3;
						  q3[c3] = c->proc;

													  /*delete proc from q0*/
						  q2[i]=NULL;
						  for(j=i;j<=c2-1;j++)
						  q2[j] = q2[j+1];
						  q2[c2] =NULL;
						  c2--;
						  }
						  c->proc = 0;
						}
				}
				if(c3!=-1){
				// if(c0!=-1)break;
				// if(c1!=-1)break;
				// if(c2!=-1)break;

					for(i=0;i<=c3;i++){
						for(int u=0;u<=c0;u++){
						if(q0[u]->state == RUNNABLE){
					  	flag1=1;
					  	break;
						}
					}
					if(flag1==1){
						break;
					}	
					for(int u=0;u<=c1;u++){
						if(q1[u]->state == RUNNABLE){
					  	flag1=1;
					  	break;
						}
					}
					if(flag1==1){
						break;
					}	
					for(int u=0;u<=c2;u++){
						if(q2[u]->state == RUNNABLE){
					  	flag1=1;
					  	break;
						}
					}
					if(flag1==1){
						break;
					}	
						  if(q3[i]->state != RUNNABLE)
							  continue;
						  p=q3[i];
						  c->proc = q3[i];
						  lastScheduled = p - ptable.proc;
					  	  p->lastexperiencedtick = xticks;
						  switchuvm(p);
						  p->state = RUNNING;
					      swtch(&(c->scheduler), p->context);
						  switchkvm();
						  if(p->ticks[3]!=0 && p->ticks[3]%(clkPerPrio[3]*10)==0){
													  /*copy proc to lower priority queue*/
						  c4++;
						  c->proc->current_queue=4;
						  q4[c4] = c->proc;

													  /*delete proc from q0*/
						  q3[i]=NULL;
						  for(j=i;j<=c3-1;j++)
						  q3[j] = q3[j+1];
						  q3[c3] =NULL;
						  c3--;
						  }
						  c->proc = 0;
						}
				}
				if(c4!=-1){
					for(i=0;i<=c4;i++){
							for(int u=0;u<=c0;u++){
						if(q0[u]->state == RUNNABLE){
					  	flag1=1;
					  	break;
						}
					}
					if(flag1==1){
						break;
					}	
					for(int u=0;u<=c1;u++){
						if(q1[u]->state == RUNNABLE){
					  	flag1=1;
					  	break;
						}
					}
					if(flag1==1){
						break;
					}	
					for(int u=0;u<=c2;u++){
						if(q2[u]->state == RUNNABLE){
					  	flag1=1;
					  	break;
						}
					}
					if(flag1==1){
						break;
					}	
					for(int u=0;u<=c3;u++){
						if(q3[u]->state == RUNNABLE){
					  	flag1=1;
					  	break;
						}
					}
					if(flag1==1){
						break;
					}	
						  if(q4[i]->state != RUNNABLE)
						  continue;
						  p=q4[i];
						  c->proc = q4[i];
						  lastScheduled = p - ptable.proc;
						  p->lastexperiencedtick = xticks;
						  switchuvm(p);
						  p->state = RUNNING;
					  		p->num_run++;

						  swtch(&(c->scheduler), c->proc->context);
						  switchkvm();
						  // cprintf("%d %d\n",p->pid,p->ticks[p->current_queue]);
												  /*move process to end of its own queue */
						  q4[i]=NULL;
						  for(j=i;j<=c4-1;j++)
						  q4[j] = q4[j+1];
						  q4[c4] = c->proc;

						  c->proc = 0;
						}
	     		}
		

	#else	
	// mlfq ended}

    // if(argv[2]=="SCHEDULER=PBS"){
	#ifdef PBS     		
    struct proc *highP = NULL;
    struct proc *p1;
    // Looking for runnable process ,if not runnable continue
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
      highP = p;	// first runnable process is considered as higher priority one
      // choose one with highest priority
      for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
        if(p1->state != RUNNABLE)
          continue;
        if ( highP->priority > p1->priority )   // larger value, lower priority 
          highP = p1;		// updating priority if higher priority one found
      }

      // if(highP->priority==30)
      // cprintf("PBS\n");
      p = highP;
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
      	p->num_run++;
      	swtch(&(c->scheduler), p->context);
      	switchkvm();		// defined in vm.c

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      	// cprintf("pid - %d,ctime - %d ;;",p->pid,p->stime);
      	c->proc = 0;
    }

    #else
      	// priority sched ended}

    // if(argv[2]=="SCHEDULER=FCFS"){
  		
    #ifdef FCFS  	
  		current_process=NULL;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    		// cprintf("FCFS\n");
      	if(p->state != RUNNABLE)
        	continue;
        if((current_process!=NULL && p->stime<current_process->stime) || (current_process==NULL) ){
        	current_process=p;
        }
    }
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
    	// cprintf("now-%d",p);
    if(current_process!=NULL){
      	p = current_process;
      	c->proc = p;
      	switchuvm(p);		// defined in vm.c
      	p->state = RUNNING;
      	p->num_run++;
      	swtch(&(c->scheduler), p->context);
      	switchkvm();		// defined in vm.c

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      	// cprintf("pid - %d,ctime - %d ;;",p->pid,p->stime);
      	c->proc = 0;
      }

    #else  	
	// fcfs ended}

	// if(argv[2]==NULL)
	// else{
    #ifdef DEFAULT
    	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    	// cprintf("DEF\n");
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);		// defined in vm.c
      p->state = RUNNING;
      p->num_run++;
      swtch(&(c->scheduler), p->context);
      switchkvm();		// defined in vm.c

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
  	}
  	#endif
    #endif
    #endif
    #endif
     // }
	// }

    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;
  // int i;
  // for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
		// if (p->state == SLEEPING && p->chan == chan){
		// 	// p->clicks = 0;
		// 	p->state = RUNNABLE;
		// 	if(p->current_queue == 0) {
		// 		c0++;
		// 		for(i=c0;i>0;i--) {
		// 			q0[i] = q0[i-1];
		// 		}
		// 		q0[0] = p;
		// 	}
		// 	else if(p->current_queue == 1) {
		// 		c1++;
		// 		for(i=c1;i>0;i--) {
		// 			q1[i] = q1[i-1];
		// 		}
		// 		q1[0] = p;
		// 	}
		// 	else if(p->current_queue == 2) {
		// 		c2++;
		// 		for(i=c2;i>0;i--) {
		// 			q2[i] = q2[i-1];
		// 		}
		// 		q2[0] = p;
		// 	}
		// 	else if(p->current_queue == 3) {
		// 		c3++;
		// 		for(i=c3;i>0;i--) {
		// 			q3[i] = q3[i-1];
		// 		}
		// 		q3[0] = p;
		// 	}
		// 	else  {
		// 		c4++;
		// 		for(i=c4;i>0;i--) {
		// 			q4[i] = q4[i-1];
		// 		}
		// 		q4[0] = p;
		// 	}

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
