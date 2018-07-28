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
**I didn't realize that someone had done part two...so I will compare my data code with yours.;
proc corr data=ProjReduced noprob plot(maxpoints=NONE)=matrix(nvar=7);
run;
**output is in the googledoc


run;



** Question 2, I did differently. First I wanted to look at the data to make sure they met the assuptions. THEN if they didn't a
**transformation would be needed.;
proc reg data=ProjReduced;
	model poverty=Pop HS College Unemployment IPC /r influence;
run;
**the above code shows that land does not need to be included in the model, so it was removed.;
title1 ’Poverty’;
proc reg data=ProjReduced;
	model poverty=Pop HS College Unemployment IPC/r partial;
	plot r.*(poverty pop hs college unemployment income);
run;

proc transreg data=ProjReduced;
	model boxcox(Pop)=identity(Poverty);
	model boxcox(PD)=identity(Poverty);
run;
**the above code gives scatterplots of the residuels to show assuptions met vs. not met. I would argue that a transformation isn't needed.
**But we may have an issue with outliers that we should do analysis on?

*Question 3;
proc reg data=ProjReduced;
	model Poverty = Unemployment IPC HS College Pop PD /selection=cp b;
run;
**Questions 3;
**Again, I used something different;
*proc reg data=work.poverty;
*title1 'Best Variables';
*model poverty=land pop hs college unemployment income/ selection = cp b best=5; 
*run;
*this shows the best model exlucdes land, but keeps all the other variables.
 
*Question 4:5;
proc reg data=ProjReduced;
	model Poverty = Unemployment IPC HS College Pop PD /selection=stepwise;
**I used this same code aside from the names;

run;

*Question 6:7;
proc reg data=ProjReduced;
	model Poverty = Unemployment IPC HS College POP PD / r clb /*etc*/

run;

quit;
