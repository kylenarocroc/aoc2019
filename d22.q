
input:(
    "deal with increment 7";
    "deal into new stack";
    "deal into new stack"
    );

.test.2:(
    "cut 6";
    "deal with increment 7";
    "deal into new stack"
    )

moves:(
    "deal with increment *";
    "deal into new stack";
    "cut *"
    );

/ deck reverse
rev:{[deck;text]
    reverse deck
    };

/ cut deck by n
cutn:{[deck;text]
    n:"I"$last " " vs text;
    take:n#deck; 
    remain:n _ deck; 
    $[1=signum n;
        remain,take; 
        take,remain
        ]
    };

/ rearrange curent deck into these positions
dealInc:{[deck;text];
    step:"I"$last " " vs text;
    deck iasc mod[;cDeck] each step*til cDeck
    };

op:0 1 2!(dealInc;rev;cutn)

run:{[ncards;input]
    funcs:op where each input like/:\: moves;
    `cDeck set ncards;
    cInp:count input;
    i:0;
   
    deck:til ncards;
    while[i<cInp;
        f:first funcs i;
        deck:f[deck;input i];
        i+:1
    ];
    
    deck

    }

.d22.p1:{
 where 2019=run[10007;read0 `:d22.txt]
 } 
 

