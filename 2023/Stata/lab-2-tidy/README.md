# MSFR Stata Lab 2: Tidy Data

Data sets often include data tables at different levels of observation. Having information about multiple levels is important, but must be managed and documented carefully. In this exercise, you will create listing data sets for several of the "units of observation" that appear in the LWH data.

Open the `lab-2.do` file in the `lab-2-tidy` folder. You will see that it contains some pseudo-code in which the tasks for this lab are described, but not implemented. You will complete each of these sections. First, turn on the logic flag for this do-file in `main.do`; and recall that the `lab-1.do` file loads the original data and saves intermediate data in the `/Stata/` folder. At all times, you will be able to reproduce the entire workflow _starting from the original data_ by running only `main.do`. We will maintain this organization through all the lab sessions.

In this lab session, we will add a second data set, which contains information about all the potential villages in the LWH data. Open that data set, and confirm that it is unique at the village level. Determine the set of variables that identifies the data set using `isid`. Do you need to rename any of the variables in this data in order to be able to `merge` it with the data from the last session? Do you need to change the variables in any other way to do so? Take a moment to `browse` both this data (and the data you saved last time) to determine the answers to these questions, and begin to write more pseudo-code (using comments) in the `lab-2.do` file documenting these needs. You will complete that coding shortly, so give yourself enough detail to do so.

In the do-file, write code to perform the cleaning that will be necessary to merge the two data sets, then do so. The beginnings of the `merge` command are written, but you will need to modify it to work correctly as well as make dataset corrections in some cases. When you are able to `merge` the two datasets, consider how many observations are in each, and how many observations should be in the resulting data. Is this data useful as it is, or is it trying to do too much? Why?

Next, you will prepare three tidy data tables from this combined information. You will first prepare a data set that contains all the households from the LWH survey. Note that `keep` has two functions: it can keep _variables_, or it can keep _observations_. Use both functionalities as necessary. Here, keep all the households that were surveyed, with the updated information about their villages (you may need options from `merge` to do this). Keep only the relevant household-level data. Then save this data.

Do the same for the villages, except in this case, keep _all_ villages, even those with no surveyed households. Use `collapse` to create summary statistics for each village - in particular, make sure this data includes the total count of households, as well as the number of households that were surveyed. Use `collapse` to calculate the _average_ and _total_ income for each village using the survey data. Similarly, calculate the _share_ of households with sheep and cows; and the _total_ purchases of sheep and cows in each village. Consider whether villages with no observations should be _zero_ or _missing_. How does that affect statistics down the line? Save this data.

Finally, starting again from the merged data, `reshape` the data so that it is "long" in crops. This means that each household may have multiple rows. Save only the data that is necessary to match this information to the other data sets, and remove information that is redundant to the village or household data. Then save this data. Can you imagine what a data map will look like for the data set with these three data tables? 