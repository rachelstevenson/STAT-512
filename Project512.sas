
*Input;
data Proj;
	infile 'Placeholder';
	input ID, County, State, Land, Pop, Young, Old, Doctors, Beds, Crime, HS, College, Poverty, Unemployment, IPC, Income, Region;

	SUM = HS + College;

	*Maybe disinclude? It's here more for my own amusement, and may cause more work. Discuss.; 
	PD = Pop/Land;

	*Question 1 piecewise framework;
	if pred1 le number
		then pieceslope=0;
	if pred1 gt number
		then pieceslope=pred1 - number;



run;

*Question 1;

*Use to find non-linear, curved function;
proc gplot data=Proj;
	symbol1 v=circle i=sm70;
	plot Poverty*Pop Poverty*HS Poverty*College Poverty*IPC Poverty*Unemployment Poverty*PD;

*Get the piecewise slopes; 
proc reg data=Proj;
	model Poverty=pred1 pieceslope;
	output out=pieceout p=povhat;

	test pred1, pieceslope;

*Set up and plot piecewise;
proc sort data=pieceout; by pred1;
proc gplot data=pieceout;
	plot (Poverty povhat)*pred1 /overlay;




*Question 2;
proc reg data=Proj;
	model
	Poverty = Pop IPC Unemployment PD;

	model 
	Poverty = Pop IPC Unemployment PD SUM;

	Nosum: test SUM=0

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
	model Poverty= POP IPC PD Unemployment HS College SUM;

	*First set of attempts: Is SUM better than HS College? Is there an individual which is best?;
	model Poverty= Pop IPC PD Unemployment SUM;

	model Poverty= Pop IPC PD Unemployment HS;

	model Poverty= Pop IPC PD Unemployment College;

	model Poverty= Pop IPC PD Unemployment HS College;

	*Second set of attempts: Is Pop better than PD? Feel free to change these based upon the first set of models.;
	model Poverty= Pop IPC Unemployment HS College SUM;

	model Poverty= PD IPC Unemployment HS College SUM;

	*Third set of attempts: Does income matter? Does unemployment? Are the two of them tied super closely?;
	model Poverty= Pop PD Unemployment HS College SUM;

	model Poverty= Pop PD IPC HS College SUM;

	model Poverty= Pop PD HS College SUM;

	*Fourth set of attempts: Come up with your own. Maybe unemployment is tied to college, high school and SUM stuff?;

run;

quit;
