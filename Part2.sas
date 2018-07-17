data Proj;
	infile 'Placeholder';
	input ID, County, State, Land, Pop, Young, Old, Doctors, Beds, Crime, HS, College, Poverty, Unemployment, IPC, Income, Region;

	SUM = HS + College;

	*Maybe disinclude? It's here more for my own amusement, and may cause more work. Discuss.; 
	PD = Pop/Land;

run;

data ProjReduced;
	set Proj (drop=ID County State Land Young Old,Doctors Beds Crime Region);

	*Any changes to the data set in part 2 should probably be done here, since ProjReduced should be the default dataset for all questions. ;

run;
*Question 1;
proc corr data=ProjReduced noprob;

run;

*Question 2;
proc transreg data=ProjReduced;
	*I have forgotten exactly how these statements work. I'll have to look through documentation.;
	model boxcox(Poverty)=identity(College);

	model boxcox(Pop)=identity(Poverty);

	model boxcox(IPC)=identity(Poverty);

	model boxcos(Unemployment)=identity(Poverty);

run;

*Question 3;
proc reg data=ProjReduced;
	model Poverty = Unemployment IPC HS College Pop PD / selection=cpb;

run;
 
*Question 4:5;
proc reg data=ProjRecuded;
	model Poverty = Unemployment IPC HS College Pop PD / selection=stepwise;

run;

*Question 6:7;
proc reg data=ProjReduced;
	model Poverty = Unemployment IPC HS College POP PD / r clb /*etc*/

run;

quit;
