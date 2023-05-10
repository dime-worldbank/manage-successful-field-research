// Beginning of do-file for Lab 2

// Open LWH data from Lab 1
use "${msfr}/lab-1/lab-1-output.dta" , clear

// Check if the data is unique in household id
isid ???

// If there are duplicates, at this stage,
  // remove them arbitrarily.
  // We'll cover more next session --
  // don't do this in real work!
  duplicates drop ???
  
 isid ???
 
preserve
  keep ???
 
  save "${msfr}/lab-2-hh-tidy.dta" , replace
restore 

  // Create village-level data set
  preserve
    keep ???
    collapse ??? ///
      , by(???)
    save "${msfr}/lab-2-vil-tidy.dta" , replace
  restore

  // Create plot-level dataset
  preserve
    keep ???
    reshape long ??? ///
      , i(???) j(???)
    save "${msfr}/lab-2-crop-tidy.dta" , replace
  restore

// End of do-file
