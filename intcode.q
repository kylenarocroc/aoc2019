/ split a single instruction into opcode and parameter modes
parseInstr:{[instruction]
	
	opcode:"I"$-2#op:"0000",string instruction; 
	paramModes:reverse "I"$/:-3#-2_op; 

	(opcode;paramModes)
	}

/ memory: 		array of memory for our program
/ memAddr:		address we're currently reading
/ paramMode:	mode of the current memory address
getAddr:{[memory;memAddr;paramMode]

	.log.debug["Parameter addr and mode";(memAddr;paramMode)];

	paramAddr:$[0=paramMode;
				memory[memAddr]; / in position mode, the value in our current address is the param address
			   1=paramMode;
			   	memAddr; / in immediate mode, our current address is our param address
			   2=paramMode;
			    memory[memAddr]+.comp.relBase; / in relative mode, we apply our relative base to our value and then the value in that address is our param address
			   'modeError
			 ];	

	.log.debug["Parameter value address";paramAddr];

	paramAddr

	}

/ read location readAddr from memory (zero fill null)
readFromAddr:{[memory;readAddr]
	/ if you retrieve a null because there's no memory, replace with zero
	0^memory[readAddr]
	}

/ write val to location writeAddr in memory
writeToAddr:{[memory;writeAddr;val]
	memory[writeAddr]:val;
	memory
	}

/ memory: 		array of memory for our program
/ writeAddr:	address we're currently reading
/ uses writeAddr since we only need to pad on write, reads zero fill nulls
padMemory:{[memory;writeAddr]
	memSize:count memory;
	if[writeAddr<0;
		'NegativeMemAddr
		];

	/ if current memory size is smaller than the address we want to read, pad with zeros
	if[memSize<=writeAddr;
		:memory,(1+writeAddr-memSize)#0
		];
	
	memory
	}

/ Apply the instruction at instrAddr in memory
/ memory
/ instrPointer
applyInstr:{[memory;instrAddr;opcode;paramModes]
	
	$[opcode=1;
		[memory:add[memory;instrAddr;paramModes]; instrAddr+:4];
	opcode=2;
		[memory:mult[memory;instrAddr;paramModes]; instrAddr+:4];
	opcode=3;
		[memory:read[memory;instrAddr;paramModes]; instrAddr+:2];
	opcode=4;
		[output[memory;instrAddr;paramModes]; instrAddr+:2];
	opcode=5;
		[instrAddr:jumpNonZero[memory;instrAddr;paramModes]];
	opcode=6;
		[instrAddr:jumpZero[memory;instrAddr;paramModes]];
	opcode=7;
		[memory:boolLessThan[memory;instrAddr;paramModes]; instrAddr+:4];
	opcode=8;
		[memory:boolEquals[memory;instrAddr;paramModes]; instrAddr+:4];
	opcode=9;
		[updateRelativeBase[memory;instrAddr;paramModes]; instrAddr+:2];
	opcode=99;
		'halt;
	/else
		'InvalidOpcode
	];

	(memory;instrAddr)

	}

/ OPERATION HELPER FUNCTIONS

/ Apply func to two values and returns single output
/ Modifies memory and returns the modified memory
applyBinaryFuncAndWrite:{[memory;instrAddr;paramModes;func]
	paramAddrs:1+n:til 3;
	paramValAddrs:getAddr[memory;;] ./: (instrAddr+paramAddrs),'paramModes n;
	
	rAddrs:paramValAddrs[0 1];
	wAddr:paramValAddrs 2;
	memory:padMemory[memory;wAddr];
	
	/ read from rAddres, apply and write to wAddr
	res:func . readFromAddr[memory;] rAddrs;
	writeToAddr[memory;wAddr;res]
	}

/ Compare with zero and modify our instruction address
/ This doesn't modify memory it just modifies our instrAddr
applyComparisonWithZero:{[memory;instrAddr;paramModes;func]
	paramAddrs:1+n:til 2;
	paramValAddrs:getAddr[memory;;] ./: (instrAddr+paramAddrs),'paramModes n;

	/ if the comparision is true, set to next parameter as the new instr addr
	newInstrAddr:$[func . (0;readFromAddr[memory;paramValAddrs 0]);
					readFromAddr[memory;paramValAddrs 1];
					instrAddr+3
				];

	newInstrAddr
	}

readWithFuncAndWrite:{[memory;instrAddr;paramModes;func]
	/ read
	res:func (::);

	/ store
	wAddr:getAddr[memory;instrAddr+1;paramModes 0];
	memory:padMemory[memory;wAddr];
	writeToAddr[memory;wAddr;res]
	}

outputWithFunc:{[memory;instrAddr;paramModes;func]
	rAddr:getAddr[memory;instrAddr+1;paramModes 0];
	
	func readFromAddr[memory;rAddr]

	}

updateRelativeBase:{[memory;instrAddr;paramModes]
	rAddr:getAddr[memory;instrAddr+1;paramModes 0];
	
	.comp.relBase:.comp.relBase+readFromAddr[memory;rAddr]
 	}

/ OPERATION DEFINITIONS

add:applyBinaryFuncAndWrite[;;;+];
mult:applyBinaryFuncAndWrite[;;;*];
read:readWithFuncAndWrite[;;;readInput];
output:outputWithFunc[;;;setOutput]
jumpNonZero:applyComparisonWithZero[;;;<>];
jumpZero:applyComparisonWithZero[;;;=];
boolLessThan:applyBinaryFuncAndWrite[;;;{`long$x<y}];
boolEquals:applyBinaryFuncAndWrite[;;;{`long$x=y}];

parseProgram:{[strInput]
	"J"$/:"," vs strInput
	}

run:{[strProgram]

	/ set up memory and parse the first instruction
	memory:parseProgram strProgram;
	
	instrAddr:0;
	instrCounter:0;
	.comp.relBase:0; 
	p:parseInstr memory[instrAddr];
	opcode:first p;
	paramModes:last p;

	/or (.debug.haltAfter>instrCounter)
	while[99<>opcode;

		.log.debug["-----------";instrCounter];
		.log.debug["(InstrAddress;opcode;ParamModes;RelBase)"; (instrAddr;opcode;paramModes;.comp.relBase)];
		.log.debug["memory"; memory];
		
		results:applyInstr[memory;instrAddr;opcode;paramModes];	
		/ results are the new memory and instruction address
		memory:results[0];
		instrAddr:results[1];
		
		/ parse the next instruction 
		p:parseInstr memory[instrAddr];
		opcode:first p;
		paramModes:last p;

		instrCounter+:1;

	];

	}


/ simulate user input using a global
readInput:{[]
    0N!"Enter some input:";
    "I"$read0 0 
    }

setOutput:{[x]
    0N!x;
    }

.log.setDebug:1b;

.log.debug:{[msg;obj]
	if[.log.setDebug;
		-1 msg," : ",-3!obj
	];
	};
