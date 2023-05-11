# MSFR Stata Lab 2: Tidy Data

Data sets often include data tables at different levels of observation. Having information about multiple levels is important, but must be managed and documented carefully. In this exercise, you will create listing data sets for several of the "units of observation" that appear in the LWH data:
1. Household level data
2. Village level data
3. Household - plot level data

Open the `lab-2.do` file. You will see that it contains some pseudo-code in which the tasks for this lab are described, but not implemented. You will complete each of these sections. First, turn on the logic flag for this do-file in `main.do`; and recall that the `lab-1.do` file loads the original data and saves intermediate data in the `/Stata/` folder. At all times, you will be able to reproduce the entire workflow _starting from the original data_ by running only `main.do`. We will maintain this organization through all the lab sessions.

1. Household level data:
- Use `isid` to see if the data is unique in household id
- Use `duplicates drop` to drop any duplicates 
- Keep the HH level information
- Save the dataset

2. Village level data ( District Sector Cell Village level):
Use `collapse` to calculate the _average_ and _total_ income for each village using the survey data. Similarly, calculate the _share_ of households with sheep and cows; and the _total_ purchases of sheep and cows in each village. 

3. Household-plot level data
- Keep the plot related variables along with household id
- `reshape` the data so that it is unique at household-plot level
- Check the data is unique at household-plot level
