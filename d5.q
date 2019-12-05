\c 1000 1000

data:first read0 `:d5.txt;

// operations dictionary to map 1 -> add and 2-> multiply
opDict:1 2 3 4 5 6 7 8!(+;*;{readInput[]};{0N!x;};<>;=;<;=);

/ parse the input array
parseData:{[inp]
	value each "," vs inp
	}

/ get your opcode and the modes for params
parseOpAndModes:{
	/ parse a halt

	if["99"~-2#string x;
		0N!"halt";
		:enlist x
		];

	op:"I"$last o:"0000",string x;

	if[any 1 2 7 8=op;
		// modes
		modes:reverse "I"$/:-3#-2_o;
		]

	if[any 3 4=op;
		modes:"I"$-1#-2_o;
	];

	if[any 5 6=op;
		// modes
		modes:reverse "I"$/:-2#-2_o;
		];

	(op;modes)

	}

/ simulate user input using a global
readInput:{[] .kc.i }

/ get correct parameters based on mode 
getD:{[l;i;mode]
	
	v:l[i];

	if[mode=0;
		:l v
		];
	if[mode=1;
		:v
		]
	}

/ loop over the the input list til we get a halt
run:{[d]
	i:0;
	n:parseData d;
	
	while[99<>op:first om:parseOpAndModes n[i];
		
		/ get modes in order
		m:last om;
		
		list:main[n;op;m;i];

		n:list[0];
		step:list[1];
		i:list[2];

		i+:step;
		];
	}

/ perform single op and update list
main:{[n;op;m;i]

	// add or multipy
	if[any 1 2 = op;
		n:@[n;n i+3;:;opDict[op] . (getD[n;i+1;m 0];getD[n;i+2;m 1])];
		step:4
	 ];

	// read input 
	if[3 = op;
		n:@[n;n[i+1];:;opDict[op] (::)];
		step:2	
	 ];

	// output 
	if[4 = op;
		opDict[op] n n[i+1];
		step:2
	 ];

	// check non zero or equal zero
	if[any 5 6= op;
		step:3;
		if[opDict[op] . (0;getD[n;i+1;m 0]);
			i:getD[n;i+2;m 1];
			step:0
			];
	 ];

	if[any 7 8=op;
		/ if true put 1, if false put 0
		n:@[n;n i+3;:;`int$opDict[op] . (getD[n;i+1;m 0];getD[n;i+2;m 1]) ];
		step:4
	 ];

	(n;step;i)

	}

.d5.p1:{.kc.i:8; run data};
.d5.p2:{.kc.i:5; run data};

// tests

d0:"3,0,4,0,99";
d1:"1002,4,3,4,33";

t1:"3,9,8,9,10,9,4,9,99,-1,8"
t2:"3,9,7,9,10,9,4,9,99,-1,8"
t3:"3,3,1108,-1,8,3,4,3,99"
t4:"3,3,1107,-1,8,3,4,3,99"
t5:"3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9"
t6:"3,3,1105,-1,9,1101,0,0,12,4,12,99,1"
t7:"3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"
