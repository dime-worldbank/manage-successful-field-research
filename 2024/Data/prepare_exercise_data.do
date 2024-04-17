	
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
	
	rename 		clustername_anonymous CLID
	
	lab def dist 	1 "District A" ///
					2 "District B" ///
					3 "District C"

	lab val district dist 				
					
	* Save 
	isid CLID, sort 
	
	save "${data}/Final/treat_status.dta", replace 
	
*------------------------------------------------------------------------------*
*	Part 1: Prepare hh- data
*------------------------------------------------------------------------------*	

	use "${data}/Raw/r1_HHData.dta", clear
	
	
	
	keep 	CLID_anonymous HHNum InterviewerID ///
			T2Q6 T2Q7 ///
			T5AQ1 T5AQ2 T5AQ3 T5AQ6 T5AQ8 ///
			T5CQ1 T5CQ2a T5CQ2b ///
			T5CQ3 T5CQ4a T5CQ4b ///
			T5CQ6a T5CQ6b  ///
			T5CQ7a T5CQ7b  ///
			T5IQ4 T5IQ5 T5IQ6 T5IQ8
			
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
	
	* Dropping variables not used
	drop 	CLID_anonymous HHNum T3Q1 T3BQ2 T3BQ4 CLID_code hh_size ///
			child_5 adult child_6_17 elderly head_female ///
			rand rank to_keep mem_id
			
	reshape wide 	T3Q3 - T3CQ13, ///
					i(HHID n_child_5 n_child_6_17 n_adult n_elder hh_head_female) ///
					j(mem_id_s) s	
					
	tempfile hh_mem
	save 	`hh_mem'
					
*------------------------------------------------------------------------------*
*	Part 4: Merge data
*------------------------------------------------------------------------------*						
					
	use `hh_data', clear
	merge 1:1 HHID using `hh_mem', keep(3) nogen 
	merge 1:1 HHID using `hh_shock', keep(3) nogen 
	
	
	iecodebook template using "${data}/codebook.xlsx" , replace

	
					
/* Notes
can merge consumption expenditure from HHConsData
can merge borrowing how much from HHCredit 	
maybe something from lviestock?
can merge other variable
