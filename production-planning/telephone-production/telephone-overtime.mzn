% Running:
% minizinc --solver CPLEX telephone-overtime.mzn telephone-overtime.dzn

int: minsInHour = 60;

enum PHONE;

array[PHONE] of int: minUnits;
array[PHONE] of int: profitPerUnit;

enum MACHINE;
array[MACHINE] of int: maxTime;
array[MACHINE] of int: maxOvertime;
array[MACHINE, PHONE] of int: timePerUnit;

int: overtimeCostPerHour;

array[PHONE] of var int: numUnits;
constraint forall(p in PHONE)(numUnits[p] >= minUnits[p]);

array[MACHINE] of var 0..infinity: overtime;
constraint forall(m in MACHINE)(overtime[m] <= maxOvertime[m] * minsInHour);

constraint forall(m in MACHINE)(
  sum(p in PHONE)(numUnits[p] * timePerUnit[m, p]) <= maxTime[m] * minsInHour + overtime[m]
);

var float: totalProfit =
  sum(p in PHONE)(numUnits[p] * profitPerUnit[p]) -
  overtimeCostPerHour * sum(m in MACHINE)(overtime[m]) / minsInHour;

solve maximize totalProfit;

output [
  "number of units: ", show(numUnits), "\n",
  "overtime (in minutes): ", show(overtime), "\n",
  "profit: ", show(totalProfit)];
