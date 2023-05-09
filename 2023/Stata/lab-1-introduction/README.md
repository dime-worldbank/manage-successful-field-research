# MSFR Stata Lab 1: Statistical Programming and Reproducibility

## Background
Critical tasks are done using statistical software so that we can easily review and revise processes. Unlike in Excel, where reverse-engineering data work is impossible, Stata lets us write "recipes" for outputs that others can easily understand, review, and update.

For the course we will work with data from the **LWH Project**, an impact evaluation of an agricultural development project (the **L**and Husbandry, **W**ater Harvesting, and **H**illside Irrigation) in Rwanda.  The baseline was conducted in 2012, and follow-up surveys in 2013, 2014, and 2016 and the surveys record information about the types and amounts of crops grown and the income derived from those crops.

There are 3 datasets.
1. ```Admin_data.dta``` - Administrative census information required for the survey.
2. ```LWH_Baseline_data_clean.dta``` - Cleaned household data from the baseline conducted
3. ```LWH_FUP2_raw_data.dta``` - Raw household survey data for the 2nd follow up round of data collection.

The questionnaire and codebooks for the 2 survey rounds are also provided.


## Setup
Download the content from the repository on your local machine. You can download the material from here.

1. Locate the `main.do` file and `README.md` for the course in the top-level directory.
2. Change the file path to match the file path on your local machine

## Lab 1

You will edit the `lab-1.do` file to complete a few basic tasks and become comfortable editing and running do-files in Stata using `global` settings and `main` do-files. In this session, we will use the `lab-1.do` file to carry out a few simple tasks using the first data set that you will be working with - ```LWH_FUP2_raw_data.dta```


You will find that the `lab-1.do` file is mainly empty. Using good structure, syntax, and style, edit the do-file to accomplish the following tasks, and run it by running the `main.do` file in the `/Stata/` folder.
1. Locate the file path for the LWH data. Using the `global` that is defined in the `main.do` file, write a command to `use` the data set and confirm the dataset loads.
2. Determine the units of observation and the unique identifying (ID) variables for the observations. Are there any duplicates? Document them now, but don't do anythign about them yet.
2. `count` the number of observations
3. `summarize` the variables
4. Use `tab` and `list` to see what some variables look like.
5. Use `help` to investigate the options available to you in these commands.

Next, open the questionnaire Excel file that describes the data set. Familiarize yourself with the documentation to determine some characteristics it should have.

1. Are there variables that, for example, have out-of-bounds values that indicate things like non-response ("-88", "-66")? Investigate these variables with `codebook`, `labelbook`, and `browse`.
2. Use `recode` to replace each of these types of survey codes with extended missing values such as `.a`. Use the `label` command to indicate what those values mean.
3. Now, the data in memory should not have any variables with survey codes such as "-66" or "-88". Write a `foreach` loop using `assert` that will check for this. You may need to use a command like `ds` and investigate what information it puts in `return` to identify all the relevant variables.
4. When you are finished checking that all extended missing values have been correctly coded, `save` the data in this folder.
