/ start slaves
/spawn:{

/ ran ports to spawn
ports:5 cut 2000+(5*120)?500;
.run.count:first "I"$.z.x;
res:();

combs:(cross/) 5#enlist 5+til 5;
combs:combs where 5=count each distinct each combs

/ start procs
run:{[phase]
 system each {"(q d7.q -p ",string[x]," &)"} each p:ports .run.count;
 system"sleep 0.5";
 .kc.phase:phase;
 `handles set ([proc:1 2 3 4 5] h:hopen each p; s:5#`running;o:phase;ic:0 0 0 0 0;oc:0 0 0 0 0;started:00000b);

 (hs:exec h from handles)@'`setStarter,/:phase;
 
 startProc[1;0];

 }

startProc:{[pNum; val]
 0N!"Starting ",string pNum;
 h:first exec h from handles where proc=pNum;
 neg[h](`start;val);
 update started:1b from `handles where proc=pNum;
 };

sendOutput:{
 / set the output and update the counter
 .kc.o:x;
 update o:x, oc:oc+1 from `handles where h=.z.w;
 /n:mod[1+handles?.z.w;5];
 n:1+mod[first exec proc from handles where h=.z.w;5];

 0N!raze"Output from ",string .z.w,": ",string[x];

 / if the program hasnt started kick it off
 if[not first exec started from handles where proc=n;
    :startProc[n;x]
    ];
 
 neg[first exec h from handles where proc=n] x;
 
 }

.z.pc:{
 /0N!"Spawning, done phase:",raze string .kc.phase;
 /-1
 res,:enlist (.kc.phase;.kc.o);
 /exit 0;
 / run the next batch
 .run.count+:1;
 if[.run.count=120;
    /"Completed; look at res";
    :(::)
    ];
 
 0N!"Final ",raze string[.kc.phase],";",string .kc.o;
 /0N!"Spawning next phase:",raze string p:combs .run.count;
 /delete handles from `.;
 exit 0
 };

run combs .run.count
