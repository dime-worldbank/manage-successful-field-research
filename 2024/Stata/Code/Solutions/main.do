* MSFR 2024 Solutions: Main do-file

	* install packages
	ssc install ietoolkit, replace
	ssc install iefieldkit, replace 
	ssc install sumstats, replace 
	
	
	*Standardize settings accross users
	ieboilstart, version(15)      //Set the version number t
	`r(version)'                 //Tactually set the version 
	
	* Define root path 
	global datawork "C:/Users/wb558768/Dropbox/MSFR 2024"
	
	* Run do files 
	do "$datawork/Code/lab1.do"