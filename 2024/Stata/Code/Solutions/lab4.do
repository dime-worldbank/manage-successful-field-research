* MSFR 2024 Solutions: Data Visualization
	
	use "$datawork/Data/Final/TZA_CCT_baseline_clean", clear
	
	//Task 1
	* Distributions
	histogram n_adult
	histogram nonfood_cons
	
	* adding discreet option for number of adults 
	histogram n_adult, discrete
	
	* frequency instead of density
	histogram n_adult, discrete frequency
	
	* density for non food consumption if it is less than 1000000
	kdensity nonfood_cons if nonfood_cons < 1000000
	
	//Task 2
	* add graph bars by vategories 
	* by enumerator 
	* pie charts
	* box plots 
	* line
	* two way scatter 
	