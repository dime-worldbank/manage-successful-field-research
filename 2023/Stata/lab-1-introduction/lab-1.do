// Beginning of do-file for Lab 1

// Use the original LWH data
use "${msfr}/raw/..." , clear

// Placeholder for assignment code

  // View data (when uncommented)
  * browse

  // Explore data (comment out with * if not needed)
  isid ???
  count ???
  summarize ??? , d
  tab ??? , plot sort
  list ??? if ???
  codebook ??? , compact

  // Explore labels
  labelbook ???

  // Revise labels
  recode ??? (-66 = ???)(-88 = ???)(???) ///
    , replace

  // Confirm all variables are cleaned
  ds , not(type str# strL)

    return list

    foreach var in `r(varlist)' {
      local label : var label `var'
      di "`var' : `label'"

      count if ???
        cap assert `r(N)' == 0
        if _rc == 0 di "`var' OK!"
        di " "
    }

// Save the resulting data
save "${msfr}/lab-1/lab-1-output.dta" , replace

// End of do-file
