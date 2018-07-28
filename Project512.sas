
*Input;
data Proj;
	infile '\\Client\D$\Downloads\S512\APPENC02.dat';
	input ID County $ State $ Land Pop Young Old Doctors Beds Crime HS College Poverty Unemployment IPC Income Region;

	SUM = HS + College;

	*Maybe disinclude? It's here more for my own amusement, and may cause more work. Discuss.; 
	PD = Pop/Land;

	*Question 1 piecewise framework;	
	if IPC le 20000
		then pieceslope=0;
	if IPC gt 20000
		then pieceslope=IPC - 20000;
	
run;

*Question 1;

*Use to find non-linear, curved function;
proc sort data=Proj;by IPC;
proc gplot data=Proj;
	symbol1 v=circle i=sm70;
	plot Poverty*Pop Poverty*HS Poverty*College Poverty*IPC Poverty*Unemployment Poverty*PD;
run;

*After this I decided upon IPC, because it looked like the most optimal one for a piecewise function.
I decided upon 20,000 as the break, because that is where the inflection point appeared to be.;

*Get the piecewise slopes; 
proc reg data=Proj;
	model Poverty=IPC pieceslope;
	output out=pieceout p=povhat;

	test pieceslope;
run;

*Set up and plot piecewise;
proc sort data=pieceout; by IPC;
proc gplot data=pieceout;
	plot (Poverty povhat)*IPC /overlay;
run;



*Question 2;
proc reg data=Proj;
	model
	Poverty = Pop IPC Unemployment PD / ss1;

	model 
	Poverty = Pop IPC Unemployment PD SUM/ ss1;

	Sum: test SUM=0;

run;

*Question 3;
proc reg data=Proj;
	model
	Poverty = Pop IPC Unemployment PD HS College/ ss1 ss2;
*Note: The reason why the ss1 and ss2 will be the same for the last value is because ss2 simply reruns the regression to find the SSE if the variable is the last variable. 
The last variable in ss1 is already last in that regression, so it won't change.;
run;

*Question 4;
proc reg data=Proj;

	*Full set;
	*Full: model Poverty= POP IPC PD Unemployment HS College SUM;

	*First set of attempts: Is SUM better than HS College? Is there an individual which is best?;
	JustSum: model Poverty= Pop IPC PD Unemployment SUM;

	JustHS:model Poverty= Pop IPC PD Unemployment HS;

	JustCollege:model Poverty= Pop IPC PD Unemployment College;

	NoSum:model Poverty= Pop IPC PD Unemployment HS College;

	*Second set of attempts: Is Pop better than PD? Feel free to change these based upon the first set of models.;
	NoPD:model Poverty= Pop IPC Unemployment HS College;

	NoPop:model Poverty= PD IPC Unemployment HS College;

	NoPDPop:model Poverty= IPC Unemployment HS College;

	*Third set of attempts: Does income matter? Does unemployment? Are the two of them tied super closely?;
	NoI:model Poverty= Pop PD Unemployment HS College;

	NoU:model Poverty= Pop PD IPC HS College;

	NoUI:model Poverty= Pop PD HS College;

	*Fourth set of attempts: Come up with your own. Maybe unemployment is tied to college, high school and SUM stuff?;

run;

quit;
