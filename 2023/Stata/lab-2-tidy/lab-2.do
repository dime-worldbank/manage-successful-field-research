// Beginning of do-file for Lab 2

// Open the original LWH administrative data
use "${msfr}/raw/..."

  // Perform necessary cleaning on administrative dataset

  // Prepare tempfile for data merge
  tempfile village
  save `village'

// Open LWH data from Lab 1
use "${msfr}/lab-1/lab-1-output.dta" , clear

  // Perform necessary cleaning on LWH dataset
  rename ///
    (??? ??? ...) ///
    (??? ??? ...)

  // Merge with administrative dataset
  merge [?:?] [varlist] ///
    using `village' ///
    , [options]

  // Create household-level data set
  preserve
    keep ???
    isid ???
    save "${msfr}/lab-2-hh-tidy.dta" , replace
  restore

  // Create village-level data set
  preserve
    keep ???
    collapse ??? ///
      , by(???)
    save "${msfr}/lab-2-vil-tidy.dta" , replace
  restore

  // Create crop-level dataset
  preserve
    reshape wide ??? ///
      , i(???) j(???)
    keep ???
    save "${msfr}/lab-2-crop-tidy.dta" , replace
  restore

// End of do-file
