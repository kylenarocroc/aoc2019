input:read0`$":d10.txt";

slp:{[p1;p2] rise:(p2[1]-p1[1]); run:p2[0]-p1[0]; s:rise%run; dir:signum rise,run; (s;dir)};

.d10.p1:{
	locs:"#"=input;
	points:raze (where each locs)(,\:)'(til count locs);
	g:{slp[points[x];] each points where not points~\:points[x]} each til count points;
	max l:{count distinct x} each g
    }

.d10.p2:{
	locs:"#"=input;
	points:raze (where each locs)(,\:)'(til count locs);
	g:{slp[points[x];] each points where not points~\:points[x]} each til count points;
	i:first where l=max l:{count distinct x} each g;

	slps:slp[points[i];] each ast:points where not points~\:points[i];

	map:group ast!slps;
	l:key map;
	tab:([] l[;0];l[;1][;0];l[;1][;1];value map);

	/ quadrant
	tab:update quadrant:0 from tab where  x1=-1,x2=0; /up
	tab:update quadrant:1 from tab where x1=-1,x2=1; / 1
	tab:update quadrant:2 from tab where x1=0,x2=1; /right
	tab:update quadrant:7 from tab where x1=-1,x2=-1; / 2
	tab:update quadrant:4 from tab where  x1=1,x2=0; /down
	tab:update quadrant:5 from tab where x1=1,x2=-1; / 3
	tab:update quadrant:6 from tab where x1=0,x2=-1; /left
	tab:update quadrant:3 from tab where x1=1,x2=1; / 4

	/ rotate
	tab:`quadrant xasc `x xasc tab;

	/ sort
	tab:update map:asc each map from tab where quadrant in 1 2 3 4;
	tab:update map:desc each map from tab where quadrant in 5 6 7 0;

	x:last (exec first each map from tab) til 200;
	(100*x[0])+x[1]
	}
