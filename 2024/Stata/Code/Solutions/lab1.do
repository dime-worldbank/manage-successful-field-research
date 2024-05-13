* MSFR 2024 Solutions: Intro to Stata							
	
	
	//Task 2
	* Load data
	use "$datawork/Data/Raw/TZA_CCT_baseline", clear
	
	* Browse the data
	browse 
	
	* Describe data 
	describe
	
	* Summarize data 
	summarize
	
	//Task 3
	* Using codebook
	codebook hh_size livestock_now
	
	* Summary 
	summarize hh_size livestock_now
	
	* histogram
	histogram food_cons
	
	* Restricting to values less than 2000000
	histogram food_cons if food_cons < 2000000
	
	//Task 4
	* using codebook on text variables
	codebook crop_other 
	
	//Task 5
	* using codebook on categorical variables
	codebook rel_head assoc
	
	* Looking for labels
	labelbook df_RELIGION
	
	* tabulate 
	tabulate rel_head 
	tabulate rel_head, nolabel 
	
	* two-way table
	tabulate rel_head female_head 
	
	* table for religion if household head is female
	tabulate rel_head if female_head == 1
	
	* count if head is female and members exceed 5
	count if female_head == 1 & hh_size > 5
	
	* count if head is female or religion is catholic
	count if female_head == 1 | rel_head == 1
	
	//Task 6
	* importign excel dataset 
	import excel using 	"$datawork/Data/Raw/treat_status.xlsx", ///
						clear ///
						first 
						
	* save in stata format
	save "$datawork/Data/Raw/treat_status.dta", replace 
	
* End of do-file!	
						
	
	
	
	