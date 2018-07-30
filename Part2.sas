
data Proj;
	infile '\\Client\D$\Downloads\S512\APPENC02.dat';
	input ID County $ State $ Land Pop Young Old Doctors Beds Crime HS College Poverty Unemployment IPC Income Region;
	SUM = HS + College;
	PD = Pop/Land; 
run;

data ProjReduced;
	set Proj (drop=ID County State Land Young Old Doctors Beds Crime Region);
run;

*Question 1;
proc corr data=ProjReduced noprob plot(maxpoints=NONE)=matrix(nvar=7);
run;

** Question 2
proc reg data=ProjReduced;
	model Poverty=Pop HS College Unemployment IPC /r influence;
run;

title1 'Poverty';
proc reg data=ProjReduced;
	model Poverty=Pop HS College Unemployment IPC/r partial;
	plot r.*(Poverty Pop HS College Unemployment IPC);
run;

proc transreg data=ProjReduced test;
	model boxcox(PD)= identity(Poverty);
run;

proc transreg data=ProjReduced test;
	model boxcox(Pop) = identity(Poverty);
run;

data ProjR;
	set ProjReduced;
	isrPop = Pop**(-0.5);
	logPD = log(PD);	
run;

proc univariate data=ProjR;
	var Poverty Unemployment IPC HS College logPD isrPop;
	qqplot / normal;
	histogram;
run;
*Question 3;
proc reg data=ProjR;
	model Poverty = Unemployment IPC HS College logPD/selection=cp b;
run;


**Questions 3;

*proc reg data=work.poverty;
*title1 'Best Variables';
*model poverty=land pop hs college unemployment income/ selection = cp b best=5; 
*run;
*this shows the best model exlucdes land, but keeps all the other variables.
 
*Question 4;
proc reg data=ProjR;
	model Poverty = Unemployment IPC HS College logPD/ selection=stepwise;
*I used this same code aside from the names;
run;

*Question 5;
proc corr data=ProjR noprob;
	var Unemployment IPC HS College logPD;
run;

*Question 6:7;
proc reg data=ProjR;
	model Poverty = IPC HS College Unemployment logPD/r p vif;
	 
run;


data ProjRd;
	set ProjR;
	if Poverty = 27.3 then delete; *Removing the outlier through brute force;
run;

proc reg data=ProjRd;
	model Poverty = IPC HS College Unemployment logPD;
run;

proc reg data=ProjR;
	*Biferoni makes it .99;
	model Poverty = IPC HS College Unemployment logPD /alpha=.01 clb;
	output out=outp p=phat;
run;

*Trying to get 95% CLI plot. Not sure this does it;
proc reg data=ProjR;
	*Biferoni makes it .99;
	model Poverty = IPC HS College Unemployment logPD /alpha=.1 clb;
	output out=outp p=phat;
run;
**this gives us the 90% CI needed for question 7

proc gplot data=outp;
	title1 '90% individual confidence interval';
	symbol1 v=star i=rlcli90;
	plot Poverty*phat;
run;

proc gplot data=outp;
	title1 '90% mean confidence interval';
	*Biferoni makes this 99%;
	symbol1 v=star i=rlclm99;
	plot Poverty*phat;
run;

quit;

proc means data=proj lclm uclm alpha=.1;
var poverty;
run;
**above code shows the CL for mean response variable (question 7 part b)
