\c 1000 1000

// operations dictionary to map 1 -> add and 2-> multiply
opDict:1 2 3 4 5 6 7 8!(+;*;{readInput[]};{setOutput x};<>;=;<;=);

/ parse the input array
parseData:{[inp]
	value each "," vs inp
	}

setOutput:{0N!x;.kc.o:x};

.state.halt:0b;

/ get your opcode and the modes for params
parseOpAndModes:{
	/ parse a halt

	if["99"~-2#string x;
		-1 "halt";
        /.state.halt:1b;
		exit 0;
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
readInput:{[]
    0N!"Enter some input: ";
    "I"$read0 0 
    }

getOutput:{[]
    0N!"Getting output";
    .kc.o
    }

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
        -1 "At output step jump";
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

