// load the array of numbers 
// use noun and verb from part 2 (can be used in part 1)
loaddata:{[x;y]
	data:value each "," vs first read0 `:d2.txt;
	data[1]:x;
	data[2]:y;
	data
	}

// operations dictionary to map 1 -> add and 2-> multiply
op:1 2!(+;*);

// Part 1.

.d2.p1:{[x;y]
	i:0;
	data:loaddata[x;y];
	while[99<>data[i]; 
	 newVal:op[data i] . (data data i+1; data data i+2);
	 data[data i+3]:newVal;
	 i+:4;
	 ];

	first data
 }

/ .d2.p1[12;2]

// Part 2.

// This is the same function as part 1 but then brute force all possible inputs
.d2.p2:{
	res:nv[where 19690720={.[.d2.p1;x;{0}]} each nv:v cross v:til 99];
	(100*first first res)+last last res 
	};

/ .d2.p2[]
