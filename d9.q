\l intcode.q

d1:"109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"
d2:"1102,34915192,34915192,7,4,7,99,0"
d3:"104,1125899906842624,99"

data:first read0 `:d9.txt
/ simulate user input using a global
readInput:{[]
    0N!"Enter some input: ";
    "I"$read0 0 
    }

setOutput:{
    /0N!"Getting output internal";
    0N!x;
    }
