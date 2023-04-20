# MSFR Stata Lab 5: Reproducible Sampling and Randomization

In this lab, you will use the materials you created in the past sessions, to create appropriate randomization and sampling code. You will assign two interventions that depend on the crops produced by the households, and you will then sample treated and un-treated households.

To begin, open the `lab-5.do` file, and, as in previous sessions, turn on its logic flag in the `main.do` file. At this point, all your prior code should run from start to finish, creating the cleaned data sets you need for this stage and the reports from last session. Now, follow the necessary steps to set up reproducible randomization: versioning, sorting, and seeding.

Next, implement a random treatment assignment across households. You will first need to create a wide household-level dataset from the appended data set using `reshape`, and you will need to use `egen` to create indicators about whether households are eligible for the intervention. In this case, create an indicator for households growing Dry Beans, and an indicator for households growing Sorghum. Select 25% of each at random. Households that grow both are potentially eligible for both interventions. Create two variables indicating these treatment and control group assignments.

Then, sample households for a follow-up survey. Create a variable indicating whether a household should be selected. Include all households that have both treatments; half of households that have one of the treatments; and, by sector, 25% of households that have neither treatment. Export the resulting intervention and observation results to Excel using `export excel`. Make sure to include variable and value labels for all the created information.
