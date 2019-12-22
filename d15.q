\l intcode.q

input:first read0`:d15.txt

move:1 2 3 4!((0;1);(0;-1);(1;0);(-1;0));

.drone.pos:(0;0)
.area.points:([] point:(); marker:());
`.area.points upsert enlist (.drone.pos; `start);
`.area.reverse set ();

readInput:{
    /0N!"Enter a move";
    n:.drone.pos+/:value move;
    .drone.move:move inp:1+first where not n in\: .area.points`point;
    / we've hit all the points and are in a dead end
    if[.drone.move~`long$();
        validPoint:first p:exec point from .area.points where point in n, marker=`hall;
        .drone.move:validPoint - .drone.pos;
        if[1=count p;
            .area.reverse,:enlist .drone.pos;
            ];
        inp:move?.drone.move
        ];

    if[(41*41)=count distinct .area.points`point;
        'complete
        ];

    0N!"Chose to move ",(1 2 3 4!"NSWE") inp;     
    inp
    }

setOutput:{
    
    $[x=0;
        [0N!"Hit wall";`.area.points upsert enlist (.drone.pos+.drone.move;`wall);];
     x=1;
        [0N!"Moved in direction"; .drone.pos+:.drone.move; `.area.points upsert enlist (.drone.pos;`hall)];
     x=2;
        [0N!"Found oxygen station"; .drone.pos+:.drone.move; `.area.points upsert enlist (.drone.pos;`oxy)];
       'InvalidOutput
       ];
   
    /draw[.area.points];
    /system"sleep 0.1";
    };

read:readWithFuncAndWrite[;;;get`readInput];
output:outputWithFunc[;;;get`setOutput]

/update points:points+19 19 from .area.points;


draw:{[tab];
    
    tab:update point:point+\:19 19 from tab;

    points:tab`point;
    /xrange:(min;max)@\: points[;0];
    /yrange:(min;max)@\: points[;1];
    
    xrange:yrange:(0;40);

    graph:(1+yrange[1]-yrange[0])#enlist (1+xrange[1]-xrange[0])#" ";

    i:0;
    c:count tab;

    while[i<c;
        p:points[i];
        m:(`wall`hall`start`oxy`rev`twice`thr!"#.D0R23") tab[i]`marker;

        graph[abs[p 1];p 0]:m;

        i+:1;
        ];
    
    -1@\:graph;

    };

.log.setDebug:0b;

inspect:{
    twos:exec point from (select count i by point from .area.points) where x=2;
    threes:exec point from (select count i by point from .area.points) where x=3;
    update marker:`twice from `.area.points where point in twos;
    update marker:`thr from `.area.points where point in threes;
    update marker:`rev from `.area.points where point in .area.reverse;
    draw .area.points
    /inspected by eye to find the corners that were double counted then take away 1
    }


fillOxy:{[];
 i:0;
 / when its 2 it will just be walls and oxygen
 while[not 2=count exec distinct marker from .area.full;
        t:(exec point from .area.full where marker=`oxy)+\:/:value move;
        update marker:`oxy from `.area.full where point in raze t,not marker=`wall;
        i+:1;
        ];
 i
 }
