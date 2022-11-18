#include<stdio.h>
int main(){
	volatile int i,j,k=0;
	for(i=0;i<20000000000000;i++){
		j=k;
	}
}