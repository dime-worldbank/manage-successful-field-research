	
	* Set root paths to the folders needed for this script
	* See https://worldbank.github.io/repkit/articles/reproot-files.html
	* for guide how to set this up
	reproot, project("msfr-course") roots("clone") prefix("msfr_")

	global data "${msfr_clone}/2024/Data"
	
*------------------------------------------------------------------------------*
*	Part 0: Prepare treatment-admin data
*------------------------------------------------------------------------------*	
	
	use "${data}/Raw/r1_CSCVillage.dta", clear
	
	keeporder 	clustername_anonymous Treatment district
	
	rename 		clustername_anonymous vid
	
	recode Treatment (2 = 0)
	
	lab def dist 	1 "District A" ///
					2 "District B" ///
					3 "District C"

	lab val district dist 				
					
	* Save 
	isid vid, sort 
	
	export excel using "${data}/Final/treat_status.xlsx", replace first(var)
		
*------------------------------------------------------------------------------*
*	Part 1: Prepare hh- data
*------------------------------------------------------------------------------*	

	use "${data}/Raw/r1_HHData.dta", clear
	
	* Calculating duration 
	gen double start = clock(T1Q3, "YMD hms")
	gen double stop = clock(T7Q3, "YMD hms")
	format start stop  %tcHH:MM
	
	gen duration = Clockdiff(start, stop, "minute")
	
	keep 	CLID_anonymous HHNum InterviewerID ///
			T2Q6 T2Q7 ///
			T5AQ1 T5AQ2 T5AQ3 T5AQ6 T5AQ8 ///
			T5CQ1 T5CQ2a T5CQ2b ///
			T5CQ3 T5CQ4a T5CQ4b ///
			T5CQ6a T5CQ6b  ///
			T5CQ7a T5CQ7b  ///
			T5IQ4 T5IQ5 T5IQ6 T5IQ8 duration AnnualFoodConsValue AnnualNonFoodConsValue
			
	* Fixing labels 
	lab var T5CQ6a "Crops grown on this owned/rented/borrowed land. FIRST"
	lab var T5CQ6b "Crops grown on this owned/rented/borrowed land. SECOND"
	
	* Dropping if missing main variables 
	drop if mi(T5AQ1)
	
	* Create unique HHID
	destring HHNum , replace
	
	gen 	CLID_code = CLID_anonymous + 90 if CLID_anonymous < 10
	replace CLID_code = CLID_anonymous if CLID_anonymous >= 10
	
	gen 	HHID = CLID_code*100 + HHNum, after(HHNum)
	
	rename 	CLID_anonymous CLID 
	
	* Create Enumerator ID 
	gen enumerator_id = substr(InterviewerID,-3, .), after(InterviewerID)
	
	destring enumerator_id, replace
	
	replace enumerator_id = 814 if enumerator_id == 807
	replace enumerator_id = 420 if enumerator_id == 819
	
	drop 	CLID_code InterviewerID
	
	* Fixing negative value in farming
	replace T5CQ2a = 2 if T5CQ2a 	< 0
	replace T5CQ4a = 4 if T5CQ4a 	< 0
	
	* repalcing units for some obs to hectares
	replace T5CQ2b = 2 if T5CQ2a > 2 & !mi(T5CQ2a)
	replace T5CQ4b = 2 if T5CQ4a > 2 & !mi(T5CQ4a)
	
	* Changing some of the units to hectare 
	foreach var_ar of varlist T5CQ2a T5CQ4a {
		
		replace  `var_ar' =  `var_ar'/2.471 if `var_ar' > 2 & !mi(`var_ar')
		
	}
	
	* Reducing categories for materials for bette rgraphs 
	replace T5AQ1 = 4 if T5AQ1 != 1
	replace T5AQ2 = 1 if inlist(T5AQ2, 3, 5, 7, 99)
	replace T5AQ3 = 4 if inlist(T5AQ3, 2, 3, 6, 99)
	
	* Conrrection in non-food consumption
	replace AnnualFoodConsValue = abs(AnnualFoodConsValue) if AnnualFoodConsValue < 0
	

	tempfile hh_data
	save 	`hh_data'
	
*------------------------------------------------------------------------------*
*	Part 2: Prepare hh-shock data
*------------------------------------------------------------------------------*	

	use "${data}/Raw/r1_HHShock.dta", clear
		
	* Create unique HHID
	destring HHNum , replace
	
	gen 	CLID_code = CLID_anonymous + 90 if CLID_anonymous < 10
	replace CLID_code = CLID_anonymous if CLID_anonymous >= 10
	
	gen 	HHID = CLID_code*100 + HHNum, after(HHNum)
		
	* DIndicator if HH suffered from drought/flood

	gen drought 		= ShockID == 1 & T5FQ1 == 1
	gen crop_damage 	= ShockID == 2  & T5FQ1 == 1
	
	collapse (max) drought crop_damage, by(HHID)
	
	rename drought 		T5FQ1
	rename crop_damage	T5FQ2
		
	lab var T5FQ1		"Experienced drought/flood"
	lab var T5FQ2		"Experienced crop damage"
	
	tempfile 	hh_shock
	save 		`hh_shock'
	
*------------------------------------------------------------------------------*
*	Part 3: Prepare hh-livestock data
*------------------------------------------------------------------------------*	

	use "${data}/Raw/r1_HHLivestock.dta", clear
	
	* Create unique HHID
	destring HHNum , replace
	
	gen 	CLID_code = CLID_anonymous + 90 if CLID_anonymous < 10
	replace CLID_code = CLID_anonymous if CLID_anonymous >= 10
	
	gen 	HHID = CLID_code*100 + HHNum, after(HHNum)
		
	collapse (sum) 	T5DQ1 T5DQ2, by(HHID)
	
	foreach lvar in T5DQ1 T5DQ2 {
		
		replace `lvar' = 0 if `lvar' < 0
		
	}
	
	tempfile hh_live
	save 	`hh_live'
	
*------------------------------------------------------------------------------*
*	Part 3: Prepare hh-other data
*------------------------------------------------------------------------------*	

	use "${data}/Raw/r1_HHOtherDescription.dta", clear	
	
	* Create unique HHID
	destring HHNum , replace
	
	gen 	CLID_code = CLID_anonymous + 90 if CLID_anonymous < 10
	replace CLID_code = CLID_anonymous if CLID_anonymous >= 10
	
	gen 	HHID = CLID_code*100 + HHNum, after(HHNum)
	
	* keep if other crop 
	keep if inlist(QuestionNumber, "T5CQ6a", "T5CQ6b")
	
	replace Description = "Coconut" if inlist(Description, "Millet", "millet")
	replace Description = "sesame" 	if inlist(Description, "Groundnuts", "Pineapple", "jathropha", "pineapple")
	
	rename Description crop_other
	
	replace QuestionNumber = "_1" if QuestionNumber == "T5CQ6a"
	replace QuestionNumber = "_2" if QuestionNumber == "T5CQ6b"
	
	keep HHID crop_other QuestionNumber
	reshape wide crop_other, i(HHID) j( QuestionNumber) s
	
	tempfile crop_other
	save 	`crop_other'
	
	
*------------------------------------------------------------------------------*
*	Part 3: Prepare hh-member data
*------------------------------------------------------------------------------*		

	use "${data}/Raw/r1_HHMember.dta", clear
	
	keep 	CLID_anonymous HHNum ///
			T3Q1 T3Q3 T3Q4 T3AQ1 ///
			T3BQ1 T3BQ2 T3BQ4 ///
			T3CQ1 T3CQ2  T3CQ4 ///
			T3CQ9 T3CQ10 T3CQ12 T3CQ13
	
	* Create unique HHID
	destring HHNum , replace
	
	gen 	CLID_code = CLID_anonymous + 90 if CLID_anonymous < 10
	replace CLID_code = CLID_anonymous if CLID_anonymous >= 10
	
	gen 	HHID = CLID_code*100 + HHNum, after(HHNum)
	
	* Construct variables 
	* HH size
	bys HHID: gen hh_size = _N
	
	* By age group (indicators)	
	gen child_5 	= T3Q4 <= 5
	gen child_6_17 	= T3Q4 >= 6 	& T3Q4 < 18
	gen adult 		= T3Q4 >= 18 	& T3Q4 < 60
	gen elderly 	= T3Q4 >= 60
	
	* Total count
	egen n_child_5 		= total(child_5)	, by(HHID)
	egen n_child_6_17 	= total(child_6_17)	, by(HHID)
	egen n_adult 		= total(adult)		, by(HHID)
	egen n_elder 		= total(elderly)	, by(HHID)
	
	* Gender of HH head
	gen head_female = T3Q3 == 2 & T3AQ1 == 1
	egen hh_head_female = max(head_female), by(HHID)
	
	* Keeping only upto 2 members per HH randomly
	set seed 123456
	
	gen 	rand = runiform()
	sort 	HHID rand, stable 
	
	by	 	HHID: gen rank = _n
	
	gen 	to_keep = rank <= 2
	
	keep if to_keep == 1
	
	bys HHID: gen mem_id = _n
	
	gen mem_id_s = "_" + string(mem_id)
	
	* Fixing negative value 
	foreach var_n of varlist T3CQ4 T3CQ13 {
		
		replace `var_n' = 10 if `var_n' == -99
		 
	}
	
	replace T3CQ10  = -88 if T3CQ10 == -99
	
	* Dropping variables not used
	drop 	CLID_anonymous HHNum T3Q1 T3BQ2 T3BQ4 CLID_code  ///
			child_5 adult child_6_17 elderly head_female ///
			rand rank to_keep mem_id
			
	reshape wide 	T3Q3 - T3CQ13, ///
					i(HHID n_child_5 n_child_6_17 n_adult n_elder hh_head_female hh_size) ///
					j(mem_id_s) s	
					
	tempfile hh_mem
	save 	`hh_mem'
					
*------------------------------------------------------------------------------*
*	Part 4: Merge data
*------------------------------------------------------------------------------*						
					
	use `hh_data', clear
	merge 1:1 HHID using `hh_mem'		, keep(3) nogen 
	merge 1:1 HHID using `hh_shock'		, keep(3) nogen 
	merge 1:1 HHID using `hh_live'		, keep(3) nogen 
	merge 1:1 HHID using `crop_other'	, keep(1 3) nogen 
	
	
	iecodebook apply using "${data}/Documentation/codebook.xlsx" 

*------------------------------------------------------------------------------*
*	Part 5: Un-clean data
*------------------------------------------------------------------------------*		
	
	* add duplicates
	expand 2 if hhid == 1045 | hhid == 1607, gen(new)
	
	* Randomize unique_key to use in ieduplicates
	set seed 545933
	isid 	hhid new, sort
	gen 	num_id = floor(runiform(1, 2)*1000000)
	ralpha 	str_id, range(A/z) l(6)
	
	gen key = substr(str_id, 1, 3) + string(num_id) + substr(str_id, -3, .)
	
	
	* Converting numeric to string for exercise
	tostring duration , replace
	
	* decoding for exercise
	decode aru_farm, gen(ar_farm_unit)


	lab var key "Unique key"
	
	drop 	new num_id str_id aru_farm
	
	order 	vid hhid enid ///
			floor roof walls water enegry ///
			rel_head female_head ///
			hh_size n_child_5 n_child_17 n_adult n_elder ///
			gender_1 - days_impact_2 ///
			food_cons nonfood_cons ///
			farm ar_farm ar_farm_unit  ///
			crop_1 crop_other_1 crop_2 crop_other_2 crop_prp_1 crop_prp_2 ///
			livestock_now livestock_before ///
			drought_flood crop_damage ///
			trust_mem trust_lead ///
			assoc health ///
			duration key
			
					
	save "${data}/Final/TZA_CCT_baseline.dta", replace
	
*************************************************************************** end!	
