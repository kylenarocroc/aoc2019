input:read0 `:d6test.q
input:read0 `:d619.txt

count input 

data:input

.d6.p1:{[data]
	map:`$/: ")" vs/: data;
	final:map[;1] where not i:map[;1] in map[;0];
	start:map[;0] where not i;
	path:final,'start;

	while[not all `COM=ends:last each path;
	    
	    0N!count ends;

	 	ends:ends nonCOM:where not `COM=ends;
		
		i:{[map;x] first where map[;1]=x}[map;] each ends;

		nextstep:map[;0] i;

		path[nonCOM]:path[nonCOM],'nextstep;

		];
	 
	
	n:1+/:til each count each orbs:reverse each path;
	//sum -1+/:count each 
	1_distinct raze n(#\:)'orbs

 }

paths:.d6.p1 input
\c 1000 1000

l:first paths where `YOU=last each paths

s:first paths where `SAN=last each paths

last l inter s

(count[l]-2)-first where l=`VZX
(count[s]-2)-first where s=`VZX

244+216


count l
count s


