\l intcode.q

input:first read0`:d17.txt
`out set ();

readInput:{
    0N!"Enter input:";
    "I"$read0 0
    };

setOutput:{

    out,:(35 46 10 60 62 94!"#.\n<>^") x;
    
    };

read:readWithFuncAndWrite[;;;get`readInput];
output:outputWithFunc[;;;get`setOutput]

move:((0;1);(0;-1);(1;0);(-1;0));

drawOutput:{
    -1@out;
    }

parseOut:{
 chop:(0,where "\n"=out) cut out;
 -2_chop except\: "\n"
 }

cOver:{
    form:parseOut[];
    p:raze (til count form) (,/:)' where each "#"=/:form;
    i:where all each "#"=/: {y ./: x}[;form] each p+/:\:move;
    p i
    }

.log.setDebug:0b;

.d17.p1:{
 run input;
 sum prd each cOver[]
 }


