* MSFR 2024 Solutions: Descriptive Analysis with tables
	
	use "$datawork/Data/Final/TZA_CCT_baseline_clean", clear
	
	//Task1A
	* summary
	summarize food_cons_w sick
	
	* tabulate
	tabulate crop_1
	tabulate crop_prp_1
	
	tabulate crop_1 crop_prp_1
	
	//Task 1B
	* defining globals with variables used for summary
	global sum_vars read sick hh_size n_child_5 n_child_17 n_adult n_elder ///
					livestock_now area_acre_w drought_flood crop_damage
	
	* tabstat for means
	tabstat $sum_vars
	
	* More summary stats
	tabstat ${sum_vars}, statistics(mean sd p50 count)
	
	* Sumamry by household head gender
	tabstat ${sum_vars}, 		///
			statistics(mean sd p50 count)	///
			by(female_head)		///
			columns(statistics)
	
	//Task 1C
	* Storing summary stats
	estpost tabstat $sum_vars, ///
					by(female_head) ///
					columns(statistics) ///
					statistics(mean sd p50 count)	///
	
	* Export summary table
	esttab using 	"$datawork/Outputs/table1.csv", ///
					replace ///
					cells((count mean sd p50)) ///
					label				
				
	// Task 1D			
	sumstats    ($sum_vars) ///
				($sum_vars if health == 1) ///
				($sum_vars if health == 0) ///
				using "$datawork/Outputs/table2.xlsx", ///
				replace stats(N mean p50 sd)
			
	//Task 2
	* Balance table by treatment status 
	iebaltab 	$sum_vars, ///
				grpvar(Treatment) ///
				rowvarlabels ///
				savexlsx("$datawork/Outputs/table3.xlsx") ///
				replace
				
	//Task 3			
	* Regressions 
	* Model 1: Regress of food consumption value on treatment
	regress food_cons_w Treatment
	eststo model1		// store regression results
	
	* Model 2: Add controls 
	regress food_cons_w Treatment read
	eststo model2
	
	* Model 3: Add clustering by village
	regress food_cons_w Treatment read, vce(cluster vid)
	eststo model3
	
	* Export results
	esttab 	model1 model2 model3 ///
			using "$datawork/Outputs/table4.csv", ///
			label ///
			replace
			
	//Task 4		
	* Summary by all 4 treatments
	collapse 	(mean) 	area_acre_w food_cons_w total_treat_cost ///
				(sum) hh_size livestock_now ///
				(count) tot_hh = hhid ///
				, by(Treatment)			
				
	* Label
	lab var area_acre_w "Average cultivated area"
	lab var food_cons_w "Average food consumption value"
	lab var total_treat_cost "Average treatment cost"
	lab var hh_size "Total members"
	lab var livestock_now "Total livestock"
	lab var tot_hh 	"Total Households"
				
	* format numeric variables
	format area_acre_w food_cons_w total_treat_cost %9.2f
	
	* Export as excel
	export excel 	using "$datawork/Outputs/table5.xlsx", ///
					first(varlabels) ///
					replace keepcellfmt
	
* End of do-file!				