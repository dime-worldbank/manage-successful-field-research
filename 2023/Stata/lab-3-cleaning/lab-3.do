// Beginning of do-file for Lab 3

// Cleaning and labelling original data

  iecodebook template "${msfr}/lab-2-hh-tidy.dta" ///
    using "${msfr}/lab-3-hh-codebook.xlsx"

  iecodebook template "${msfr}/lab-2-vil-tidy.dta" ///
    using "${msfr}/lab-3-vil-codebook.xlsx"

  iecodebook template "${msfr}/lab-2-hh-tidy.dta" ///
    using "${msfr}/lab-3-crop-codebook.xlsx"

// Cleaning and combining original data with new data


  // Save the combined household data
  iecodebook export ///
    using "${msfr}/lab-3-hh-clean.dta" ///
    , [options]

  // Save the combined crop data
  iecodebook export ///
    using "${msfr}/lab-3-crop-clean.dta" ///
    , [options]


// End of do-file
