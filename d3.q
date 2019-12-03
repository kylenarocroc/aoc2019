/data:"," vs/: ("R75,D30,R83,U83,L12,D49,R71,U7,L72";"U62,R66,U55,R34,D71,R55,D58,R83")
/data:"," vs/: ("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51";"U98,R91,D20,R16,D67,R40,U7,R15,U6,R7")
input:read0`:d3.txt

setup:{
	// load data and parts out directions
	data:"," vs/: input;
	dirFlags:first''[data];
	dirs:"UDLR"!((0;1);(0;-1);(-1;0);(1;0));
	moves:"J"${1_x}''[data];
	points:dirs each dirFlags;
	// moves are the number of steps to take in a given direction
	// points are the unit vectors from the origin for each move
	(moves;points)
	}

path:{[m;p]
  nMoves:til each 1+m;
  lines:p(*/:)'nMoves;
  {(-1_x),(last x)+/:y}/[first lines;1_lines]
 }

genRoutes:{
	path ./: flip setup[]
	}

.d3.p1:{[]
	routes:genRoutes[];
	min (sum each abs (inter) . routes) except 0
	}

.d3.p2:{
	routes:genRoutes[];
	first min 1_ sum ({[points;intersects] where each points~\:/: intersects}[;(inter) . routes]) each routes 	
	}

/.d3.p1[]
/.d3.p2[]
