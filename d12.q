/input:read0`:d12.txt
/ d12.txt below
input:(
	"<x=-15, y=1, z=4>";
	"<x=1, y=-10, z=-8>";
	"<x=-5, y=4, z=9>";
	"<x=4, y=6, z=-2>"
	)

input2:(
	"<x=-1, y=0, z=2>";
	"<x=2, y=-10, z=-7>";
	"<x=4, y=-8, z=8>";
	"<x=3, y=5, z=-1>"
	)

input3:(
	"<x=-8, y=-10, z=0>";
	"<x=5, y=5, z=10>";
	"<x=2, y=-7, z=3>";
	"<x=9, y=-8, z=-3>"
	)

points:();

run:{[p;v;i] l:((<;=) .\: enlist p[i])  .\:/: enlist each p til[4] except i; np:p[i]+nv:v[i]+sum (eq l[;1])@''mov l[;0]; (np;nv)}

energy:{[pv] sum (sum each abs pv[;0])*sum each abs pv[;1]}

.d12.p1:{	
	`points set ();
	{[str] value str; points,:enlist (x;y;z);} each  -1_/:1_/:ssr[;",";";"] each ssr[;"=";":"] each input;

	`mov set 01b!(-1;1);
	`eq set 01b!((::);{0});

	i:0;
	pv:run[points; 4#enlist (0;0;0);] each til 4;
	sims:10000;
	while[i<sims-1;

		pv:run[pv[;0]; pv[;1];] each til 4;
		i+:1;

	];

	energy[pv]

	}

run:{[p;v;i] l:((<;=) .\: enlist p[i])  .\:/: enlist each p til[2] except i; np:p[i]+nv:v[i]+sum (eq l[;1])@''mov l[;0]; (np;nv)}
energy:{[pv] sum (sum each abs pv[;0])*sum each abs pv[;1]}

`mov set 01b!(-1;1);
`eq set 01b!((::);{0});

input:read0`:d12.txt

setPoints:{
 `points set ();
 {[str] value str; points,:enlist (x;y;z);} each  -1_/:1_/:ssr[;",";";"] each ssr[;"=";":"] each input;
 };

onedim:{[dir;i]

	m:((<;=)@\:dir[i]) @\: dir (til 4) except i;
	(eq m[1])@'mov m[0]
	
	}

calc:{
	
	pos:x[0];
	vel:x[1];
	pos:pos + vel:vel+sum each onedim[pos;] each til 4;

    / check position and velocity together 
    / to see if we're back at the start
    if[(pos;vel)~.initial.pv;
		:()
		];
    
    .count.runs+:1;
    
    (pos;vel)

	}

rundim:{[dim]
    setPoints[]; 
    .initial.pv:(points[;dim];0 0 0 0);
    .count.runs:0;
    (calc/)[{not ()~x};.initial.pv]; 
    .count.runs+1
	}

// Ran with rundim each 0 1 2 -> then found lowest common multiple out of those numbers
