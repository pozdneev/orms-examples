int: minsInHour = 60;

enum PHONE;

array[PHONE] of int: minUnits;
array[PHONE] of int: profitPerUnit;

enum MACHINE;
array[MACHINE] of int: maxTime;
array[MACHINE, PHONE] of int: timePerUnit;

array[PHONE] of var int: numUnits;
constraint forall(p in PHONE)(numUnits[p] >= minUnits[p]);

constraint forall(m in MACHINE)(sum(p in PHONE)(numUnits[p] * timePerUnit[m, p]) <= maxTime[m] * minsInHour);

var int: totalProfit = sum(p in PHONE)(numUnits[p] * profitPerUnit[p]);

solve maximize totalProfit;

output [show(numUnits), "\n", show(totalProfit)];
