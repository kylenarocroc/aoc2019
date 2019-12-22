map:"=>" vs/: read0 `:d14.txt
map:"=>" vs/: (
 "9 ORE => 2 A";
 "8 ORE => 3 B";
 "7 ORE => 5 C";
 "3 A, 4 B => 1 AB";
 "5 B, 7 C => 1 BC";
 "4 C, 1 A => 1 CA";
 "2 AB, 3 BC, 4 CA => 1 FUEL";
 ""
 );

start:where map[;1] like "*FUEL"; 
parts:first ", " vs/: map[;0] start;
factors:"(1%",/:(map[;1][;0]),\:")*";
singles:factors,'map[;0];
outs:last each " " vs/:map[;1];

/{
/ num:"I"$x 0;
/ x[0]:"*"
/ need:map[;1] i:first where map[;1] like x;
/ inps:map[;0] i
/ }

inputs:", " vs/: map[;0];

split:" " vs/: 1_/:map[;1];
cast:{"IS"$'x};
outputs:cast each -1_split

inputs:" " vs/:/:-1_(-1_/:inputs),'enlist each -1_/:last each inputs;
inputs:cast''[inputs]

factors:first''[inputs]
syms:last''[inputs]
single:factors*(1%outputs[;0])



