input:read0 `:d6.txt

.d6.p1:{[]
	map:`$/: ")" vs/: input;
	d:(`u#map[;1])!map[;0];
	s:key[d] where not i:key[d] in value d;
	s:s,'ends:d[s];
	while[not all `=ends:d[ends];
	 	s:s,'ends
		];

 	s:s except\: `;
	n:neg 1+/:til each count each s;
	
	count each s

	sum -1+/:count each 1_distinct raze n(#\:)'s
 }

.d6.p2:{[]
	map:`$/: ")" vs/: input;
	d:(`u#map[;1])!map[;0];
	s:key[d] where not i:key[d] in value d;
	s:s,'ends:d[s];
	while[not all `=ends:d[ends];
	 	s:s,'ends
		];
		
	s:s except\: `;
	n:neg 1+/:til each count each s;
	
	f:{[s;x] s first where x=first each s};
	you:f[s;`YOU];
	san:f[s;`SAN];

	-2+sum raze where each (you;san)=/:first (you inter san)
 };



