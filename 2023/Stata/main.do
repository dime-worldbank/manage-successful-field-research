// Main do-file for MSFR 2023 Stata labs

// Install necessary packages

  ssc install ietoolkit
  ssc install iefieldkit

// Clear environment

  ieboilstart, version(16.1)
 `r(version)'

// Set file path global for Stata labs

  // Change this to the correct location!
  global msfr "/Users/bbdaniels/GitHub/manage-successful-field-research/2023/Stata"

// Run each of the do-files with logic flags

  // Change each (0) to (1) when you are ready to run that file
  if (0) do "${msfr}/lab-1-introduction/lab-1.do"
  if (0) do "${msfr}/lab-1-introduction/lab-2.do"
  if (0) do "${msfr}/lab-1-introduction/lab-3.do"
  if (0) do "${msfr}/lab-1-introduction/lab-4.do"
  if (0) do "${msfr}/lab-1-introduction/lab-5.do"

// End of main do-file
