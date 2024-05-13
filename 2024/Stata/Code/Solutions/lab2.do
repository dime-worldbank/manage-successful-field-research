* MSFR 2024 Solutions: Cleaning and construction
	
	use "$datawork/Data/Raw/TZA_CCT_baseline.dta", clear
	
	// Task 1
	* Check if hhid is unique
	*isid hhid
	unique hhid
	
	// Task 2
	* Identify duplicates 
	ieduplicates	hhid ///
					using "$datawork/Outputs/duplicates.xlsx", ///
					uniquevars(key)
					
	isid hhid
	
	//Task 3
	* table for crop_other
	tabulate crop_other 
	
	* proper case
	replace crop_other = proper(crop_other)
	
	* Removing special chars: replace every occurence of "." with "" 
	replace crop_other = subinstr(crop_other, ".", "", .) 
	
	* Remove extra spaces
	replace crop_other = strtrim(crop_other)
	
	* Reducing categories
	// replacing to coconuts if first 4 letters are Coco
	replace crop_other = "Coconuts" if substr(crop_other, 1, 4) == "Coco"
	
	
	//Task 4
	* check hich variabels are string 
	ds, has(type string)
	
	* checking codebook 
	codebook ar_farm_unit crop_other duration key, compact
	
	//Task 5
	* Ecnoding area farm unit
	encode ar_farm_unit, generate(ar_unit)
	
	labelbook ar_unit
	
	//Task 6
	summarize
	
	recode treat_cost_1 treat_cost_2 assoc 	(-88 = .d)
	recode trust_mem trust_lead health 		(88 = .d)
	
	sum treat_cost_1 treat_cost_2 assoc
	
	//Task 7
	ds, has(type string)
	
	destring duration, replace 
	
	//Task 8
	* Area in acre
	* Equal to area farm if unit is acres, otherwise multiplied by 2.47
	generate 	area_acre = ar_farm 		if ar_unit == 1 
	replace 	area_acre = ar_farm * 2.47 	if ar_unit == 2
	
	* If HH has any livestock
	generate livestock = livestock_now > 0
	
	//Task 9
	* if either member can read
	egen read = anymatch(read_1 read_2), values(1)
	
	* if any memebr is sick
	egen sick = anymatch(sick_1 sick_2), values(1)
	
	* total treatment cost
	egen total_treat_cost = rowtotal(treat_cost_1 treat_cost_2)
	
	//Task 10
	histogram area_acre
	histogram food_cons
	
	summarize area_acre, detail
	summarize food_cons, detail
	
	//Task 11
	winsor area_acre, p(0.05) gen(area_acre_w) high
	winsor food_cons, p(0.05) gen(food_cons_w) high
	
	//Task 12
	* merging treatment status
	merge m:1 vid using "$datawork/Data/Raw/treat_status.dta"
	
	//Task 13
	* labeling variables
	label variable area_acre 		"Area cultivated (Acres)"
	label variable livestock 		"Owns Livestock"
	label variable read 			"Atleast one member can read/read"
	label variable sick 			"Atleast one member was sick in the last 4 weeks"
	label variable total_treat_cost "Total cost of treatment"
	label variable area_acre_w 		"Area cultivated (Acres) wisorized 0.05"
	label variable food_cons_w 		"Annual food consumption value (Winsorized 0.05)"
	
	
	* assign value labels
	label value livestock read sick yesno
	
	* create new value label for treatment
	label define treat 1 "Treatment" 0 "Control"
	
	label value Treatment treat
	
	drop ar_farm_unit _merge

	order ar_unit area_acre	area_acre_w	, after(ar_farm)
	order livestock						, before(livestock_now)
	order read sick total_treat_cost	, before(food_cons)
	order food_cons_w					, after(food_cons)
	
	save "$datawork/Data/Final/TZA_CCT_baseline_clean", replace
	
	//Task 15
	* Collapse by village id with average food consumption and area, total members 
	* and total households in the village
	collapse 	(mean) food_cons area_acre ///
				(sum) hh_size ///
				(count) hhid, ///
				by(vid Treatment district)
		
	//Task 16
	* Create a iecodebook template and then replace template with apply 
	* iecodebook
	*iecodebook template using "$datawork/Outputs/codebook.xlsx", replace
	
	* repalce template with apply 
	iecodebook apply using "$datawork/Outputs/codebook.xlsx"
	
	* Save the dataset 
	save "$datawork/Data/Final/TZA_CCT_baseline_village.dta", replace
	
* End of do-file!		
	