\l intcode.q

data:first read0 `:d11.txt
/ turn debug off initially
.log.setDebug:0b;

/ left 90 = 0
/ right 90 = 1 
mDict:(!) . flip (
	(`up; 		((-1;0);(1;0))); 
	(`left; 	((0;-1);(0;1)));
	(`right;	((0;1);	(0;-1)));
	(`down; 	((1;0);	(-1;0)))
	)

dDict:(!) . flip (
	(`up; 		(`left;`right)); 
	(`left; 	(`down;`up));
	(`right;	(`up;`down));
	(`down; 	(`right;`left))
	)


move:{[dir; point; move]
	/ pick out the correct step based on the move from the dict
	/ add to point to get our next point 
	
	newPoint:point+mDict[dir] move;
	newDir:dDict[dir] move;
	/ null fill because all colors start as black 
	newColor:0^first value exec last color by point from state where point~\:newPoint;

	.state.current:(newDir; newPoint; newColor);
	`state insert .state.current;
	
	}

/ set customer read write functions 
readInput:{
	/ last element of state list is color
	.state.current[2]
	}

.output.i:0; / count n outputs and mod 2 to choose what we do 

/ 0 is paint the square
/ 1 is move and update full state
setOutput:{[x]
	$[0=.output.i mod 2;
		[.state.current[2]:x; `state insert .state.current]; / update current state color to output and insert into state table
	  1=.output.i mod 2;
	  	move[.state.current 0; .state.current 1;x]; / updates current state to be correct for the new point
	  'outputerr
	  ];

	.output.i+:1

	};


read:readWithFuncAndWrite[;;;readInput];
output:outputWithFunc[;;;setOutput]


.d11.p1:{
	/ color 0=black, 1=white 
	/ dir `up`down`left`right
	/ point x;y coords from (0;0) starting point
	`state set ([] dir:(); point:(); color:());

	/ start up at centre on a black square
	.state.current:(`up; (0;0); 0);
	`state insert .state.current;

	run data;

	exec count distinct point from state

	}

.d11.p2:{
	/ color 0=black, 1=white 
	/ dir `up`down`left`right
	/ point x;y coords from (0;0) starting point
	`state set ([] dir:(); point:(); color:());

	/ start up at centre on a black square
	.state.current:(`up; (0;0); 1);
	`state insert .state.current;

	run data;

	colors:0!select last color by point from state;
	
	points:exec point from colors;
	xrange:(min;max)@\: points[;0];
	yrange:(min;max)@\: points[;1];

	graph:(1+yrange[1]-yrange[0])#enlist (1+xrange[1]-xrange[0])#" ";
	
	i:0;
	c:count colors;

	while[i<c;
		p:(colors i)`point;
		color:(colors i)`color;

		mark:(0 1!" #") color;
		/0N!"updated graph";
		graph[abs[p 1];p 0]:mark;

		i+:1;
	];

	-1@/:graph;

	}
