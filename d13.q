\l intcode.q

input:first read0`:d13.txt

outputlist:();
inputlist:();
.output.i:0
.output.prev:0;
.output.isScore:0b;
.output.score:0;

.input.start:0;
.input.i:0;

instr:"asd"!(-1;0;1);

readInput:{
	
	drawScreen[];
	.input.i+:1;
	inp:$[.paddle.pos[0]<.ball.pos[0];
		1;
	.paddle.pos[0]=.ball.pos[0]; / stay same 
		0;
	.paddle.pos[0]>.ball.pos[0]; / move left
		-1;
	'paddleError
		];
	
	`outputlist set ();

	inp

	}

setOutput:{[x]

	/ add to outputlist
	outputlist,:x;
	
	.output.i+:1;
	.output.prev:x;

	};


setOutput:{[x]
	/ score
	if[(-1;0)~-2#outputlist;
		.score.score:x
	];


	/ add to the outputlist
	outputlist,:x;

	};


read:readWithFuncAndWrite[;;;get`readInput];
output:outputWithFunc[;;;get`setOutput]

drawScreen:{
	/ drop of the outputs we had previous
	
	checks:3 cut outputlist;	
	i:0;
	points:checks[;0 1];
	npoints:count points;

	if[.input.i=0;
		xrange:(min;max)@\: points[;0];
		yrange:(min;max)@\: points[;1];
		`graph set (1+yrange[1]-yrange[0])#enlist (1+xrange[1]-xrange[0])#" ";
	];

 	picture:0 1 2 3 4!(" |#=o");

	while[i<npoints;

		p:points i;

		mark:picture checks[;2] i;
		
		/ sort ball pos
		if[mark~"o"; .ball.pos:p];
		if[mark~"="; .paddle.pos:p];

		if[not (-1;0)~p;
			graph[abs[p 1];p 0]:mark;
			];

		i+:1;
		];
	-1@/:graph;

	}



.log.setDebug:0b;

.d13.p1:{
	run input;
	l:3 cut outputlist;
	sum l[;2]
	};

.d13.p2:{
	`outputlist set ();

	/ play for free
	input[0]:"2";

	run input
	}
