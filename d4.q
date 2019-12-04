// non-vectorised and slow
// but low memory usage

input:"206938-679128";

run:{[f]
	r:value each "-" vs input;

	i:r[0];
	cnt:0;	
	while[i<r[1];
		if[f[i];
			cnt+:1;
			];
		i+:1
		];
	cnt
 };

check1:{[x]
	s:10 vs x;
	(not 6=count distinct s) and (all 0<=deltas s)
	
 };

check2:{[x]
	s:10 vs x;
	y:l first where 2=count each l:group s;
	(all 0<= deltas s) and (1=y[1]-y[0])
 }

.d4.p1:{run[check1]};
.d4.p2:{run[check2]};
