# MSFR Stata Lab 4: Data Analysis and Descriptive Statistics

Creating rapid reports in Office-type software can be done quickly and reproducibly using Stata. You can re-use code easily if you structure it well up-front. In this session, you will create a Word document with figures and tables describing sampling, tracking, and loss to follow up between the two rounds of the survey you compiled in the last session.

To begin, open the `lab-4.do` file, and, as in previous sessions, turn on its logic flag in the `main.do` file. At this point, all your prior code should run from start to finish, creating the cleaned data sets you need for this stage. This means that all variables should be ready to use for analysis - there should be no missing information, zeros should be in the right place, data should be combined appropriately, and we are ready to move to analytical outputs.

We will not be creating new derived data in this exercise; in general, this is when that step would happen. But since we do not have a project or research design here, we will skip that step for now, and simply create a report about the data we have cleaned to this point. Specifically, we will create a report documenting the data collection across the two rounds of agricultural data you have cleaned.

First, we will document the size and scope of data collection. Use `putdocx` to open a `.docx` file in which you will place all these results. Like all Stata commands, this is expected to be reproducible, so remember to use options like `replace` in the initial command so that the entire document is re-created in each run. Unfortunately, the exact syntax for these commands has changed over time, so you will need to review the help file carefully depending on your Stata version.

When `putdocx` is set up, create two tables indicating the numbers of households and villages that are observed (and not observed) in the first and second rounds of the data collection. There are a number of ways to do this; many tables can be effectively created by first creating a matrix or data set with the results, then using the appropriate `putdocx table` command (or equivalent syntax).

Next, load all the crop-level data, and create an image comparing the types of crops. Which ones are increasing in frequency between the two rounds? In revenue? Create two or three images summarizing these distributions and comparisons across the three most common crops and across the two data collection rounds. Use `graph` or  `twoway` to do so. See [this page](https://dimewiki.worldbank.org/Stata_Coding_Practices:_Visualization) at the DIME Wiki for more details and some ideas. Use `graph export` to save the images you create as `.png` files, and then use `putdocx image` (or equivalent) to insert the same into your report. Use `putdocx text` (or equivalent) to add some information describing your tables and figures, in the appropriate places.