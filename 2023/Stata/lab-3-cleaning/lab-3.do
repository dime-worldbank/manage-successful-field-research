// Beginning of do-file for Lab 3

// If you like, go back to Lab 2 and handle duplicates correctly.

// Cleaning and labelling original data
// When done setting up template, change to iecodebook apply
// Use help file and DIME Wiki!

  iecodebook template "${msfr}/lab-2-hh-tidy.dta" ///
    using "${msfr}/lab-3-hh-codebook.xlsx"

  iecodebook template "${msfr}/lab-2-vil-tidy.dta" ///
    using "${msfr}/lab-3-vil-codebook.xlsx"

  iecodebook template "${msfr}/lab-2-hh-tidy.dta" ///
    using "${msfr}/lab-3-crop-codebook.xlsx"

// Cleaning and combining baseline data with followup data

  // Load and clean followup date
  use "${msfr}/raw/???.dta" , clear

    // Resolve duplicates here if necessary
    ieduplicates ???

    // Set up template, then change and apply changes
    iecodebook template ///
      using "${msfr}/lab-3-followup.xlsx"

    // Save cleaned data
    save "${msfr}/lab-3-followup.dta" , replace

  // Use baseline data, then append followup data
  use "${msfr}/???.dta" , clear
    append using "${msfr}/lab-3-followup.dta" , gen(???)

    lab var ??? ???
    lab def ??? ???
    lab val ??? ???

  // Save the combined household data with codebooks
  iecodebook export ///
    using "${msfr}/lab-3-hh-clean.xlsx" ///
    , save [options]

// End of do-file
