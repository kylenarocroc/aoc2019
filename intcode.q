\c 1000 1000

// operations dictionary to map 1 -> add and 2-> multiply
opDict:1 2 3 4 5 6 7 8!(+;*;{readInput[]};{setOutput x};<>;=;<;=);

/ parse the input array
parseData:{[inp]
	value each "," vs inp
	}

setOutput:{0N!x;.kc.o:x};

/ system params
.state.halt:0b;
relativeBase:0;

/ get your opcode and the modes for params
parseOpAndModes:{
	/ parse a halt
	op:"I"$-2#o:"0000",string x;
	
	if[99~op;
		-1 "halt";
        :enlist x
		];

	if[any 1 2 7 8=op;
		// modes
		modes:reverse "I"$/:-3#-2_o;
		]

	if[any 3 4 9=op;
		modes:"I"$-1#-2_o;
	];

	if[any 5 6=op;
		// modes
		modes:reverse "I"$/:-2#-2_o;
		];

	if[not all modes<3; 'modeError];

	(op;modes)

	}

/ simulate user input using a global
readInput:{[]
    0N!"Enter some input: ";
    "I"$read0 0 
    }

setOutput:{[x]
    0N!"Getting output";
    .kc.o:x
    }

/ get correct parameters based on mode 
getD:{[l;i;mode]

	v:0^l[i];

    / position mode 
	if[mode=0;
		:0^l v
		];

	/ immediate mode
	if[mode=1;
		:v
		]

 	/ relative mode - index with the offset
	if[mode=2;
		rel:relativeBase+l[i];
		:0^l[rel]
	 	]
	}

/ get corect parameters based on mode 
access:{[l;i;mode]

	v:l[i];

    / position mode 
	if[mode=0;
		:v
		];

 	/ relative mode - index with the offset
	if[mode=2;
		:l[relativeBase+i];
	 	]
	}

write:{[l;i;mode]
	
	if[mode=0;
		:0^l[i]
		];

	if[mode=2;
		:0^l[i]+relativeBase
		];

 }

/ loop over the the input list til we get a halt
run:{[d]
	i:0;
	n:parseData d;
	
	while[99<>op:first om:parseOpAndModes n[i];
		/0N!"ops modes";
		/0N!om;
		/ get modes in order
		m:last om;
		
		list:main[n;op;m;i];

		n:list[0];
		step:list[1];
		i:list[2];

		i+:step;
		];
    
	}

/ extend end by posToHit zeros
pad:{[n;posToHit]
	if[count[n]<=posToHit;
		:n,(1+posToHit - count[n])#0
		];
	n
 	}

/ perform single op and update list
main:{[n;op;m;i]
	
	/0N!"Status:";
	/0N!op;
	/0N!m;
	/0N!n;

	// add or multipy
	if[any 1 2 = op;
		/ pad mem with zeros first
		n:pad[n;write[n;i+3;m 2]];
		n:@[n;write[n;i+3;m 2];:;opDict[op] . (getD[n;i+1;m 0];getD[n;i+2;m 1])];
		step:4
	 ];

	// read input 
	if[3 = op;
		/ pad mem with zeros first
		n:pad[n;write[n;i+1;m]];
		
		n:@[n;write[n;i+1;m];:;opDict[op] (::)];
		step:2	
	 ];

	// output 
	if[4 = op;
		o:$[m=2;relativeBase+n i+1;m=0;n i+1;m=1;i+1;'outerr];
		opDict[op] n o;
		step:2
	 ];

	// jumps
	// check non zero (5) or equal zero (6)
	if[any 5 6= op;
		step:3;
		if[opDict[op] . (0;getD[n;i+1;m 0]);
			i:getD[n;i+2;m 1];
			/ pad if i jump to a far location
			n:pad[n;i];
			step:0
			];
	 ];


	// args check
	if[any 7 8=op;
		n:pad[n;write[n;i+3;m 2]];

		v:`long$opDict[op] . (getD[n;i+1;m 0];getD[n;i+2;m 1]);
		/ if true put 1, if false put 0
		n:@[n;write[n;i+3;m 2];:;v];
		step:4
	 ];

	 / adjust the relativeBase
	 if[9 = op;
	 	/0N!"updating rel base: ",string i;
	 	/if[(i=21)&m=2;'s];
	 	`relativeBase set relativeBase+o:$[m=2;n relativeBase+n i+1;m=0;n n i+1;m=1;n i+1;'outerr];
	 	/0N!relativeBase;
	 	step:2
	 ];

	(n;step;i)
    
   }

