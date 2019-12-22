\l intcode.q

input:first read0`:d15.txt

move:1 2 3 4!((0;1);(0;-1);(1;0);(-1;0));

.drone.pos:(0;0)
.area.points:([] point:(); marker:());
`.area.points upsert enlist (.drone.pos; `start);

readInput:{
    /0N!"Enter a move";
    n:.drone.pos+/:value move;
    .drone.move:move inp:1+first where not n in\: .area.points`point;
    / we've hit all the points and are in a dead end
    if[.drone.move~`long$();
        validPoint:first exec point from .area.points where point in n, marker=`hall;
        .drone.move:validPoint - .drone.pos;
        inp:move?.drone.move
        ];

    0N!"Chose to move ",(1 2 3 4!"NSWE") inp;     
    /.drone.move:move inp;
    inp
    }

setOutput:{
    
    $[x=0;
        [0N!"Hit wall";`.area.points upsert enlist (.drone.pos+.drone.move;`wall);];
     x=1;
        [0N!"Moved in direction"; .drone.pos+:.drone.move; `.area.points upsert enlist (.drone.pos;`hall)];
     x=2;
        [0N!"Found oxygen station"; .drone.pos+:.drone.move; `.area.points upsert enlist (.drone.pos;`oxy); 'bingo];
       'InvalidOutput
       ];
    
    };

read:readWithFuncAndWrite[;;;get`readInput];
output:outputWithFunc[;;;get`setOutput]

/update points:points+19 19 from .area.points;


draw:{[tab];
   
    points:tab`point;
    xrange:(min;max)@\: points[;0];
    yrange:(min;max)@\: points[;1];

    graph:(1+yrange[1]-yrange[0])#enlist (1+xrange[1]-xrange[0])#" ";

    i:0;
    c:count tab;

    while[i<c;
        p:points[i];
        m:(`wall`hall`start`oxy!"#.D0") tab[i]`marker;

        graph[abs[p 1];p 0]:m;

        i+:1;
        ];
    
    -1@\:graph;

    };

.log.setDebug:0b;

