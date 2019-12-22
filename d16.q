.test.1:"80871224585914546619083218645595";
.test.2:"19617804207202209144916044189917";
.test.3:"69317163492948606335995924319873";

/ p2 tests
.test.4:"03036732577212944063491565474664";
.test.5:"02935109699940807407585447034323";
.test.6:"03081770884921959731165446850517";

getsplit:{"I"$/:x};
getsize:{count split};
makegrid:{pat each 1+til size};
step:{raze x#/:base};
pat:{t:1+size div count pattern:step x;size#1_raze t#enlist pattern};
phase:{[s] mod[;10] each abs sum each grid*\:s};

base:0 1 0 -1;

run:{[nphases]
 `split set getsplit[input];
 `size set getsize[];
 `grid set makegrid[];
 phase/[nphases;split]
 }
 
big:{[input]
 `input set raze 10000#enlist input;
 offset:"I"$7#input;
 out:run[100];
 8#offset_out
 }; 

.d16.p1:{
 `input set first read0 `:d16.txt;
 8#run[100]
 }

.d16.p2:{
 
 inp:first read0 `:d16.txt;
 big[inp] 
 }
