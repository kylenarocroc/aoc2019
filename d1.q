// Day 1.

// Run solutions as .d1.p1[] and .d1.p2[]

// Globals used in both parts
// load data & define fuel calc
data:value each read0 `:d1.txt;
fuel:{-2+floor x%3};

// Part 1.

// apply fuel calc to each module and sum
.d1.p1:{sum fuel each data}

// Part 2.

.d1.p2:{
    // recursively apply the fuel calc to each module
    // See: https://code.kx.com/v2/ref/accumulators/#while
    allfuel:{fuel\[0<;x]} each data;

    // drop first and last entry and sum across everything
    sum sum each 1_/:-1_/:allfuel
    };




