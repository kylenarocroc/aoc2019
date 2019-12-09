
input:first read0`:d8.txt;

countN:{[x;y] (sum/) y=x};


.d8.p1:{
    layers:6 cut 25 cut input;
    layer:layers first where l=min l:countN[;"0"] each layers;
    countN[layer;"1"]*countN[layer;"2"]
    }

/0 black
/1 white
/2 transp

.d8.p2:{[x;y]
 / x is the larger number 
 p:(x*y) cut input;
 t:ssr[;"1";"\333"] each ssr[;"0";" "] each 25 cut k@'first each where each not "2"=k:flip p;
 -1@/:t;
 }
