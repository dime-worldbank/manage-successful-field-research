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
	* Bar graph of damage by crop
	gr bar 			crop_damage
	gr bar 			crop_damage, over(Treatment) 	// By treatment 
	gr bar (median) crop_damage, over(Treatment)	// Median
	
	
	//Task 3
	* Bar graph for sources of water 
	gr bar, over(water)
	
	* gr bar with formatting
	gr hbar	, 	over(water)  ///
				title("Main source of drinking water") ///
				ytitle("Percent") ///
				blabel(bar, format(%9.1f)) ///
				bar(1, color(green)) ///
				graphregion(color(white))
			
	* Soorting by bar height		
	gr hbar	, 	over(water, sort(1))  ///
				title("Main source of drinking water") ///
				ytitle("Percent") ///
				blabel(bar, format(%9.1f)) ///
				bar(1, color(green)) ///
				graphregion(color(white))			

	//Task 4
	* Box plot of duration over enumerators 
	gr box 		duration, ///
				over(enid, sort(1)) ///
				title("Distribution of duration across enumerators") ///
				graphregion(color(white))
			
	//Task 5
	* Pie chart for religion
	gr pie, 	over(rel_head) ///
				sort ///
				title("Religion of the household head") ///
				graphregion(color(white))
			
					
	//Task 6
	* two way scatter between non-food and food consumtion
	twoway scatter 	nonfood_cons food_cons, ///
					title("Food and Non-food consumption value") ///
					ylabel(,angle(0)) ///
					graphregion(color(white)) name(g1, replace)
					
	//Task 7
	* kdensity curves of winsorized food consumption for three districts
	gr twoway 	(kdensity food_cons_w if district == "District A") ///
				(kdensity food_cons_w if district == "District B") ///
				(kdensity food_cons_w if district == "District C")
				
	* Adding titles 			
	gr twoway 	(kdensity food_cons_w if district == "District A") ///
				(kdensity food_cons_w if district == "District B") ///
				(kdensity food_cons_w if district == "District C"), ///
				title("Distribution of food consumption by districts") ///
				ytitle("Density") ///
				xtitle("Food consumption value")
				
	* Add labels to legend
	gr twoway 	(kdensity food_cons if district == "District A") ///
				(kdensity food_cons if district == "District B") ///
				(kdensity food_cons if district == "District C"), ///
				title("Distribution of food consumption by districts") ///
				ytitle("Density") ///
				xtitle("Annual food consumption value") ///
				legend(order(1 "District A" 2 "District B" 3 "District C") row(1)) ///
				graphregion(color(white)) ylabel(,angle(0)) name(g2, replace)
				
	//Task 8
	* combine graphs
	gr combine 	g1 g2, ///
				cols(1) ///
				xcommon ///
				graphregion(color(white)) ///
				note("Source: Household survey")
				
	//Task 9		
	* Saving graph 
	gr export "$datawork/Outputs/graph1.png", replace
	
* End of do-file!	