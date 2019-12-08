/ needs cleanup

/ run in shell:
/for i in {0..10}; do echo $i; q master.q $i &> log.log; done

/monitor output then when finished run 
/grep "Final" log.log > output.txt 
/ to get the final numbers

/ Parse and get the max
/n:"I"$/:";" vs/: -1_/:7_/:read0 `:output.txt
/max n[;1]


\l intcode.q

data:first read0`:d7.txt
/data:"3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0";

/data:"3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5"

/data:"3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10"
/data:"3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0"
/data:"3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0"

combs:(cross/) 5#enlist 5+til 5;
combs:combs where 5=count each distinct each combs;

setup:{[i]
    .kc.o:0; / used as the first signal
    .r.i:0;
    .r.ilist:i;
    }

/p1
execute:{[i]
    setup[i];
    
    (5#run)@\:data;

    getOutput[]
    }

/ p1
readInput:{
    
    0N!"Reading input";

    x:$[1=mod[.r.i;2];
        / use input from last program
        getOutput[];
        .r.ilist[.r.i div 2]
        ];
    0N!"Input read: ",string x;
    .r.i+:1; / increase the number of reads we've done
    x
    }

/ read input from the master handle
readInput:{
    /0N!"Enter input:";
    /.kc.i:"I"$read0 .master.h;
    
    / block and wait for a message from the master,
    / then value the response
    / if its the first go then read the starter
    /inp:$[not .kc.read;
    /    [.kc.read:1b;0N!"Reading starter"; .kc.starter];
    /    [
         /0N!"askin for in";
         /neg[.master.h]"giveInput[]"; /say im waiting for input
    /     .kc.i
    /     ]
    /    ];

    / early exit on first go
    if[not .kc.read; .kc.read:1b; -1 "Read starter"; :.kc.starter];
    -1 "Reading input: ",string .kc.i;
    .kc.i
    };

/setInput:{.kc.i:x};

/ keep master handle
.z.po:{
 .master.h:x
 };

setOutput:{
 .kc.o:x;
 neg[.master.h](`sendOutput;x);
 -1 "Sending output";
 .kc.i:.master.h[];
 }

setStarter:{
 .kc.starter:x;
 }

.kc.read:0b;
/.kc.starter:9;
start:{.kc.i:x;run data};

i1:"4,3,2,1,0";
i2:"0,1,2,3,4";
i3:"1,0,4,3,2";
i4:"9,8,7,6,5";
i5:"9,7,8,5,6";


t1:"3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0";
t2:"3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0";
t3:"3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0";
t4:"3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5";
t5:"3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10"
